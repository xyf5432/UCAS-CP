// RISCVCodeGenerator.cpp
#include "RISCVCodeGenerator.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/ADT/SmallVector.h" 
#include "llvm/IR/GetElementPtrTypeIterator.h"
#include "llvm/ADT/APFloat.h"      
#include "llvm/ADT/APInt.h"        
#include "llvm/Support/raw_ostream.h" 
#include <iostream>
#include <sstream>

#define DEBUG_LOG 1 // 设置为 1 开启调试, 设置为 0 关闭

#if DEBUG_LOG
#define LOG_INSTRUCTION(I) std::cout << "[VISIT] " << valueToString(&(I)) << "\n"
#define LOG_FUNC(F) std::cout << "\n\n[FUNC] Processing function: @" << (F).getName().str() << "\n"
#define LOG_BB(BB) std::cout << "[BB]   Processing basic block: " << (BB).getName().str() << "\n"
#define LOG_LOAD(val, ptr, reg) std::cout << "[LOAD]   lw " << (reg) << ", 0(" << valueToString(ptr) << ") -> value: " << valueToString(val) << "\n"
#define LOG_STORE(val, ptr) std::cout << "[STORE]  sw " << valueToString(val) << ", 0(" << valueToString(ptr) << ")\n"
#define LOG_ADDR(val, reg) std::cout << "[ADDR]   la/addi " << (reg) << ", " << valueToString(val) << "\n"
#else
#define LOG_INSTRUCTION(I)
#define LOG_FUNC(F)
#define LOG_BB(BB)
#define LOG_LOAD(val, ptr, reg)
#define LOG_STORE(val, ptr)
#define LOG_ADDR(val, reg)
#endif

void RISCVCodeGenerator::generate(llvm::Module* module, const std::string& filename) {
    out.open(filename);
    if (!out.is_open()) {
        std::cerr << "Error: Could not open output file " << filename << std::endl;
        return;
    }
    this->current_module = module;
    visitModule(module);
    out.close();
}

void RISCVCodeGenerator::processGlobals(llvm::Module* module) {
    out << ".data\n";
    const llvm::DataLayout& dl = module->getDataLayout();  // 获取DataLayout
    for (const llvm::GlobalVariable& global : module->globals()) {
        uint64_t size = dl.getTypeAllocSize(global.getValueType());
        out << "  .type " << global.getName().str() << ", @object\n";
        out << "  .size " << global.getName().str() << ", " << size << "\n";
        out << global.getName().str() << ":\n";
        if (global.hasInitializer()) {
            emitConstant(out, global.getInitializer()); // **使用新的辅助函数**
        } else {
            uint64_t size = dl.getTypeAllocSize(global.getValueType());
            out << "  .zero " << size << "\n";
        }
    }
    out << "\n";
}

void RISCVCodeGenerator::loadAddressOfValueToReg(llvm::Value* value, const std::string& reg) {
    LOG_ADDR(value, reg);
    if (auto* G = llvm::dyn_cast<llvm::GlobalValue>(value)) {
        out << "  la   " << reg << ", " << G->getName().str() << "\n";
    } else if (stack_offsets.count(value)) {
        // For a value on the stack, its address is s0 + offset
        out << "  addi " << reg << ", s0, " << stack_offsets[value] << "\n";
    } else {
        out << "  # ERROR: Cannot get address of this value\n";
    }
}


void RISCVCodeGenerator::visitModule(llvm::Module* module) {
    processGlobals(module);

    out << ".text\n";
    
    // If there is a main function, declare it as global
    if (module->getFunction("main")) {
        out << ".globl main\n";
        out << ".type main, @function\n";
    }

    for (llvm::Function& F : *module) {
        if (!F.isDeclaration()) {
            visitFunction(F);
        }
    }
}

void RISCVCodeGenerator::visitFunction(llvm::Function& F) {
    LOG_FUNC(F);
    out << "\n" << F.getName().str() << ":\n";
    current_function = &F;
    epilogue_label = "." + F.getName().str() + "_epilogue";
    stack_offsets.clear();
    
    // --- Pass 1: Allocate stack space ---
    
     const llvm::DataLayout& dl = F.getParent()->getDataLayout();
    auto getAlignedSize = [&](llvm::Type* type) {
        uint64_t size = dl.getTypeAllocSize(type);
        // 向上对齐到4字节
        return (size + 3) & ~3; 
    };

    int size_for_locals = 0; // Total space for locals, temps, and arg backups

    // Space for argument backups on the stack
    for (auto& arg : F.args()) {
        size_for_locals += getAlignedSize(arg.getType());
    }

    // Space for alloca instructions and instruction results
    for (llvm::BasicBlock& BB : F) {
        for (llvm::Instruction& I : BB) {
            if (auto* allocaInst = llvm::dyn_cast<llvm::AllocaInst>(&I)) {
                // Alloca 已经是对齐的
                size_for_locals += dl.getTypeAllocSize(allocaInst->getAllocatedType());
            } 
            else if (!I.getType()->isVoidTy()) {
                size_for_locals += getAlignedSize(I.getType());
            }
        }
    }

    // Total stack frame size = fixed area + locals area
    int fixed_size = 16 + 32; // 16 bytes for ra/s0, 32 bytes for t0-t6 caller-saved registers
    current_stack_size = fixed_size + size_for_locals;
    
    // Align the final stack size to a 16-byte boundary
    if (current_stack_size % 16 != 0) {
        current_stack_size += 16 - (current_stack_size % 16);
    }
    
    // --- Pass 1.5: Assign stack offsets ---
    // Offsets are negative, relative to the frame pointer s0.
    // The local data area starts right below the fixed area.
    int current_offset = -fixed_size; 

    // Assign offsets for argument backups
    for (auto& arg : F.args()) {
        uint64_t size = getAlignedSize(arg.getType());
        // The offset points to the TOP of the allocated space for the value.
        stack_offsets[&arg] = current_offset;
        current_offset -= size;
    }
    
    // Assign offsets for alloca instructions and instruction results
    for (llvm::BasicBlock& BB : F) {
        for (llvm::Instruction& I : BB) {
            if (auto* allocaInst = llvm::dyn_cast<llvm::AllocaInst>(&I)) {
                uint64_t size = dl.getTypeAllocSize(allocaInst->getAllocatedType());
                stack_offsets[allocaInst] = current_offset;
                current_offset -= size;
            } 
            else if (!I.getType()->isVoidTy()) {
                uint64_t aligned_size = getAlignedSize(I.getType());
                stack_offsets[&I] = current_offset;
                current_offset -= aligned_size;
            }
        }
    }
    
    // --- Pass 2: Generate code ---
    functionPrologue(F);

    // Store function arguments from registers (a0, fa0, ...) to their stack slots
    int int_arg_idx = 0;
    int float_arg_idx = 0;
    for (auto& arg : F.args()) {
        if (arg.getType()->isFloatTy()) {
            if (float_arg_idx < 8) {
                storeFloatRegToValue("fa" + std::to_string(float_arg_idx), &arg);
            }
            float_arg_idx++;
        } else {
            if (int_arg_idx < 8) {
                storeRegToValue("a" + std::to_string(int_arg_idx), &arg);
            }
            int_arg_idx++;
        }
    }
    
    for (llvm::BasicBlock& BB : F) {
        visitBasicBlock(BB);
    }
    
    out << epilogue_label << ":\n";
    functionEpilogue(F);
}

void RISCVCodeGenerator::visitBasicBlock(llvm::BasicBlock& BB) {
    LOG_BB(BB);
    // Basic block names from LLVM IR might contain illegal characters, so sanitize them
    out << "." << BB.getParent()->getName().str() << "_" << BB.getName().str() << ":\n";
    for (llvm::Instruction& I : BB) {
        visitInstruction(I);
    }
}

void RISCVCodeGenerator::functionPrologue(llvm::Function& F) {
    // s0 is used as the frame pointer (fp)
    out << "  # Function Prologue for " << F.getName().str() << "\n";
    out << "  addi sp, sp, -" << current_stack_size << "\n"; // Allocate stack frame
    out << "  sw   ra, " << (current_stack_size - 4) << "(sp)\n"; // Save return address
    out << "  sw   s0, " << (current_stack_size - 8) << "(sp)\n"; // Save old frame pointer
    out << "  addi s0, sp, " << current_stack_size << "\n"; // Set new frame pointer
    
}

void RISCVCodeGenerator::functionEpilogue(llvm::Function& F) {
    out << "  # Function Epilogue for " << F.getName().str() << "\n";
    out << "  lw   ra, " << (current_stack_size - 4) << "(sp)\n"; // Restore return address
    out << "  lw   s0, " << (current_stack_size - 8) << "(sp)\n"; // Restore old frame pointer
    out << "  addi sp, sp, " << current_stack_size << "\n"; // Deallocate stack frame
    out << "  ret\n"; // ret is a pseudo-instruction for 'jalr zero, 0(ra)'
}

// --- Helper function implementations ---
std::string RISCVCodeGenerator::getStackAddress(llvm::Value* value) {
    if (stack_offsets.count(value)) {
        return std::to_string(stack_offsets[value]) + "(s0)";
    }
    // Handle constants
    if (auto* C = llvm::dyn_cast<llvm::ConstantInt>(value)) {
        return std::to_string(C->getSExtValue()); // Return the immediate value directly
    }
    // Global variables
    if (auto* G = llvm::dyn_cast<llvm::GlobalValue>(value)) {
        return G->getName().str();
    }
    return "UNKNOWN_VALUE";
}

void RISCVCodeGenerator::loadValueToReg(llvm::Value* value, const std::string& reg) {
    if (auto* C = llvm::dyn_cast<llvm::ConstantInt>(value)) {
        long long val = C->getSExtValue();
        
        // **核心修复：正确处理 lui/addi 的立即数**
        // addi 的立即数是12位有符号数。
        // 我们需要将 val 分解为：val = (high_part << 12) + low_part
        // 其中 low_part 在 [-2048, 2047] 范围内。
        
        int low12 = val & 0xFFF; // 取低12位
        // 如果低12位的符号位（第11位）是1，说明它应该被解释为一个负数
        if (low12 & 0x800) {
            low12 -= 0x1000; // 手动进行符号扩展，例如 4095 (0xFFF) -> -1
        }
        
        int high20 = (val - low12) >> 12;

        // 如果 low12 是0，可以优化掉 addi
        if (low12 == 0) {
            out << "  lui  " << reg << ", " << high20 << "\n";
        } else {
            out << "  lui  " << reg << ", " << high20 << "\n";
            out << "  addi " << reg << ", " << reg << ", " << low12 << "\n";
        }

    } else if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(value)) {
        out << "  # FATAL ERROR: loadValueToReg called with a float constant! Check the caller.\n";
        return;
    } else if ((value->getType()->isIntegerTy() || value->getType()->isPointerTy())) {
        // 从栈或全局变量加载
        out << "  lw   " << reg << ", " << getStackAddress(value) << "\n";
    } else {
        // 如果一个浮点值被传到这里，说明调用者（如visitStoreInst或visitCallInst）出错了
        out << "  # FATAL ERROR: Trying to load a float value using lw. Check the caller.\n";
    }
}

void RISCVCodeGenerator::storeRegToValue(const std::string& reg, llvm::Value* value) {
    out << "  sw   " << reg << ", " << getStackAddress(value) << "\n";
}

// 将一个浮点值加载到指定的浮点寄存器 (e.g., "ft0")
void RISCVCodeGenerator::loadFloatValueToReg(llvm::Value* value, const std::string& reg) {
    if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(value)) {
        std::string temp_reg = "t3";
        llvm::APInt int_val = CF->getValueAPF().bitcastToAPInt();
        long long val = int_val.getZExtValue();
        
        // **修复：使用 lui 和 addi 加载32位立即数**
        unsigned int high20 = (val >> 12);
        unsigned int low12 = val & 0xFFF;
        if (low12 & 0x800) high20++;

        out << "  lui  " << temp_reg << ", " << high20 << "\n";
        out << "  addi " << temp_reg << ", " << temp_reg << ", " << (short)low12 << "\n";

        std::string temp_slot = "-32(s0)";
        out << "  sw   " << temp_reg << ", " << temp_slot << "\n";
        out << "  flw  " << reg << ", " << temp_slot << "\n";
    } else {
        out << "  flw  " << reg << ", " << getStackAddress(value) << "\n";
    }
}

// 将一个浮点寄存器 (e.g., "ft0") 的值存到一个Value对应的栈位置
void RISCVCodeGenerator::storeFloatRegToValue(const std::string& reg, llvm::Value* value) {
    out << "  fsw  " << reg << ", " << getStackAddress(value) << "\n";
}

void RISCVCodeGenerator::emitConstant(std::ofstream& out, const llvm::Constant* C) {
    if (auto* CI = llvm::dyn_cast<llvm::ConstantInt>(C)) {
        out << "  .word " << CI->getSExtValue() << "\n";
    } else if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(C)) {
        out << "  .word 0x" << std::hex << CF->getValueAPF().bitcastToAPInt().getZExtValue() << std::dec << "\n";
    } else if (auto* CA = llvm::dyn_cast<llvm::ConstantArray>(C)) {
        for (unsigned i = 0; i < CA->getNumOperands(); ++i) {
            emitConstant(out, CA->getOperand(i));
        }
    } else if (auto* CS = llvm::dyn_cast<llvm::ConstantStruct>(C)) {
        for(unsigned i = 0; i < CS->getNumOperands(); ++i) {
            emitConstant(out, CS->getOperand(i));
        }
    } else if (llvm::dyn_cast<llvm::ConstantAggregateZero>(C)) {
        // --- 修复点 1 ---
        const llvm::DataLayout& dl = current_module->getDataLayout(); // 使用成员变量
        uint64_t size = dl.getTypeAllocSize(C->getType());
        out << "  .zero " << size << "\n";
    } else if (auto* CDA = llvm::dyn_cast<llvm::ConstantDataArray>(C)) {
         if (CDA->isString()) {
             out << "  .string \"" << CDA->getAsString().str() << "\"\n";
         } else { 
             for (unsigned i = 0; i < CDA->getNumElements(); ++i) {
                  if (CDA->getElementType()->isIntegerTy()) {
                     out << "  .word " << CDA->getElementAsInteger(i) << "\n";
                  }
             }
         }
    } else {
        // --- 修复点 2 ---
        const llvm::DataLayout& dl = current_module->getDataLayout(); // 使用成员变量
        uint64_t size = dl.getTypeAllocSize(C->getType());
        out << "  .zero " << size << "\n";
    }
}

// --- Instruction dispatcher ---
void RISCVCodeGenerator::visitInstruction(llvm::Instruction& I) {
    LOG_INSTRUCTION(I);
    // Print the instruction as a comment for easier debugging
    std::string instStr;
    llvm::raw_string_ostream rso(instStr);
    I.print(rso);
    out << "  # " << instStr << "\n";
    
    // Dispatch using llvm::isa and llvm::dyn_cast
    if (auto* inst = llvm::dyn_cast<llvm::ReturnInst>(&I)) {
        visitReturnInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::BinaryOperator>(&I)) {
        visitBinaryOperator(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::AllocaInst>(&I)) {
        // Alloca was already handled in the first pass, do nothing here
    } else if (auto* inst = llvm::dyn_cast<llvm::LoadInst>(&I)) {
        visitLoadInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::StoreInst>(&I)) {
        visitStoreInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::BranchInst>(&I)) {
        visitBranchInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::CallInst>(&I)) {
        visitCallInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::ICmpInst>(&I)) {
        visitICmpInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::GetElementPtrInst>(&I)) { 
        visitGetElementPtrInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::PHINode>(&I)) { 
        visitPHINode(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::CastInst>(&I)) { 
        visitCastInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::FCmpInst>(&I)) { 
        visitFCmpInst(*inst);
    } else if (auto* inst = llvm::dyn_cast<llvm::UnaryOperator>(&I)) {
        if (inst->getOpcode() == llvm::Instruction::FNeg) {
            loadFloatValueToReg(inst->getOperand(0), "ft0");
            out << "  fneg.s ft1, ft0\n";
            storeFloatRegToValue("ft1", inst);
        }
    } else {
        out << "  # WARNING: Unhandled instruction: " << I.getOpcodeName() << "\n";
    }
}

// --- Specific instruction implementations ---

void RISCVCodeGenerator::visitReturnInst(llvm::ReturnInst& I) {
    if (llvm::Value* retVal = I.getReturnValue()) {
        if (retVal->getType()->isFloatTy()) {
            loadFloatValueToReg(retVal, "fa0"); // **修复：浮点返回值用 fa0**
        } else {
            loadValueToReg(retVal, "a0");
        }
    }
    out << "  j    " << epilogue_label << "\n";
}

void RISCVCodeGenerator::visitBinaryOperator(llvm::BinaryOperator& I) {
    bool isFloat = I.getType()->isFloatTy();

    if (isFloat) {
        // --- 浮点处理 ---
        loadFloatValueToReg(I.getOperand(0), "ft0");
        loadFloatValueToReg(I.getOperand(1), "ft1");

        std::string opcode;
        switch (I.getOpcode()) {
            case llvm::Instruction::FAdd: opcode = "fadd.s"; break;
            case llvm::Instruction::FSub: opcode = "fsub.s"; break;
            case llvm::Instruction::FMul: opcode = "fmul.s"; break;
            case llvm::Instruction::FDiv: opcode = "fdiv.s"; break;
            default: opcode = "UNSUPPORTED_FP_OP"; break;
        }

        out << "  " << opcode << " ft2, ft0, ft1\n";
        storeFloatRegToValue("ft2", &I);

    } else {
        // --- 整数处理 (你的现有代码) ---
        llvm::Value* op1 = I.getOperand(0);
        llvm::Value* op2 = I.getOperand(1);
        loadValueToReg(op1, "t0");
        loadValueToReg(op2, "t1");
        std::string opcode;
        switch (I.getOpcode()) {
            case llvm::Instruction::Add:  opcode = "add"; break;
            case llvm::Instruction::Sub:  opcode = "sub"; break;
            case llvm::Instruction::Mul:  opcode = "mul"; break;
            case llvm::Instruction::SDiv: opcode = "div"; break;
            case llvm::Instruction::SRem: opcode = "rem"; break;
            // ... add more cases for AND, OR, XOR, etc.
            default: opcode = "UNSUPPORTED_OP"; break;
        }
        
        out << "  " << opcode << " t2, t0, t1\n";
        storeRegToValue("t2", &I);
    }
}

void RISCVCodeGenerator::visitLoadInst(llvm::LoadInst& I) {
    llvm::Value* ptr = I.getPointerOperand();
    bool isFloat = I.getType()->isFloatTy();
    
    if (auto* GEP = llvm::dyn_cast<llvm::GetElementPtrInst>(ptr)) {
        // 如果指针是GEP指令的结果，它的地址已经被计算并存在栈上了
        loadValueToReg(GEP, "t0");
    } else if (auto* CE = llvm::dyn_cast<llvm::ConstantExpr>(ptr)) {
        if (CE->getOpcode() == llvm::Instruction::GetElementPtr) {
            // --- 正确处理常量GEP表达式 ---
            // 1. 获取基地址到 t0
            llvm::Value* BasePtr = CE->getOperand(0);
            loadAddressOfValueToReg(BasePtr, "t0");

            // 2. 累加偏移量
            const llvm::DataLayout& dl = current_function->getParent()->getDataLayout();
            llvm::Type* CurrentTy = BasePtr->getType();

            // 手动迭代，因为常量表达式没有 gep_type_iterator
            for (unsigned i = 1; i < CE->getNumOperands(); ++i) {
                llvm::Value* IdxValue = CE->getOperand(i);

                if (auto* PtrTy = llvm::dyn_cast<llvm::PointerType>(CurrentTy)) {
                    CurrentTy = PtrTy->getElementType();
                } else if (auto* ArrayTy = llvm::dyn_cast<llvm::ArrayType>(CurrentTy)) {
                    CurrentTy = ArrayTy->getElementType();
                }
                
                uint64_t ElementSize = dl.getTypeAllocSize(CurrentTy);

                if (auto* CI = llvm::dyn_cast<llvm::ConstantInt>(IdxValue)) {
                    long long offset = CI->getSExtValue() * ElementSize;
                    if (offset != 0) {
                        out << "  addi t0, t0, " << offset << "\n";
                    }
                }
            }
             // 此时 t0 中是计算好的地址
        }
    } else {
        loadAddressOfValueToReg(ptr, "t0");
    }

    if (isFloat) {
        LOG_LOAD(&I, ptr, "ft0");
        out << "  flw  ft0, 0(t0)\n";       // 使用 flw 加载浮点数
        storeFloatRegToValue("ft0", &I); // 存到浮点结果
    } else {
        LOG_LOAD(&I, ptr, "t1");
        out << "  lw   t1, 0(t0)\n";         // 使用 lw 加载整数
        storeRegToValue("t1", &I);      // 存到整数结果
    }
}

void RISCVCodeGenerator::visitStoreInst(llvm::StoreInst& I) {
    llvm::Value* val = I.getValueOperand();
    llvm::Value* ptr = I.getPointerOperand();
    LOG_STORE(val, ptr);

    // 1. 获取要写入的目标地址，存入 t1 寄存器
    // --- 这是本次修正的核心 ---
    if (llvm::isa<llvm::AllocaInst>(ptr) || llvm::isa<llvm::GlobalVariable>(ptr)) {
        // 如果指针是 alloca 或 global variable，它本身就是地址的“符号”，
        // 我们需要计算它的运行时地址。
        loadAddressOfValueToReg(ptr, "t1");
    } else {
        // 如果指针是 GEP、load 等指令的结果，那么它的值（目标地址）已经
        // 被计算好并存在它自己的栈槽里了，我们需要把它加载出来。
        loadValueToReg(ptr, "t1");
    }
    
    // 2. 根据值的类型，加载到对应的寄存器并存储
    if (val->getType()->isFloatTy()) {
        // --- 浮点数路径 ---
        // a. 将要存储的浮点值加载到临时浮点寄存器 ft0
        loadFloatValueToReg(val, "ft0");
        // b. 用 fsw 将 ft0 存入 t1 指向的地址
        out << "  fsw  ft0, 0(t1)\n";
    } else {
        // --- 整数/指针路径 ---
        // a. 将要存储的整数/指针值加载到临时整数寄存器 t0
        loadValueToReg(val, "t0");
        // b. 用 sw 将 t0 存入 t1 指向的地址
        out << "  sw   t0, 0(t1)\n";
    }
}

// RISCVCodeGenerator.cpp
void RISCVCodeGenerator::visitBranchInst(llvm::BranchInst& I) {
    if (I.isConditional()) {
        llvm::Value* cond = I.getCondition();
        llvm::BasicBlock* trueDest = I.getSuccessor(0);
        llvm::BasicBlock* falseDest = I.getSuccessor(1);
        std::string trueLabel = "." + trueDest->getParent()->getName().str() + "_" + trueDest->getName().str();
        std::string falseLabel = "." + falseDest->getParent()->getName().str() + "_" + falseDest->getName().str();
        
        // --- START OF NEW LOGIC ---

        // 在这里，当前块（I.getParent()）即将终结。
        // 我们需要生成代码，根据条件`cond`跳转到不同的路径。
        // 在每个路径上，我们必须为该路径的目标块的PHI节点提供值。

        std::string falsePathLabel = "." + I.getParent()->getName().str() + "_br_false_path_" + std::to_string(reinterpret_cast<uintptr_t>(&I));

        // 1. 加载条件并进行主分支
        loadValueToReg(cond, "t0");
        out << "  beqz t0, " << falsePathLabel << "\n";

        // 2. TRUE PATH: 这部分代码只有在 cond 为 true 时执行
        //    为 trueDest 的所有 PHI 节点准备 incoming value
        for (llvm::PHINode& phi : trueDest->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2"); // Use a temp reg
            storeRegToValue("t2", &phi);
        }
        //    跳转到真正的 trueDest 基本块
        out << "  j " << trueLabel << "\n";

        // 3. FALSE PATH: 这部分代码只有在 cond 为 false 时执行
        out << falsePathLabel << ":\n";
        //    为 falseDest 的所有 PHI 节点准备 incoming value
        for (llvm::PHINode& phi : falseDest->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2"); // Use a temp reg
            storeRegToValue("t2", &phi);
        }
        //    跳转到真正的 falseDest 基本块
        out << "  j " << falseLabel << "\n";
        
        // --- END OF NEW LOGIC ---

    } else { // Unconditional Branch
        llvm::BasicBlock* dest = I.getSuccessor(0);
        std::string destLabel = "." + dest->getParent()->getName().str() + "_" + dest->getName().str();

        // 为目标块的所有 PHI 节点准备 incoming value
        for (llvm::PHINode& phi : dest->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        // 直接跳转
        out << "  j " << destLabel << "\n";
    }
}

void RISCVCodeGenerator::visitCallInst(llvm::CallInst& I) {
    out << "  # --- Saving caller-saved registers before call ---\n";
    // 我们将 t0-t6 保存到 s0 下方的固定暂存区 (-16 到 -48 的位置)
    for (int i = 0; i <= 6; ++i) {
        // -16(s0) 是 ra, -20(s0) 是 t0, -24(s0) 是 t1, ...
        out << "  sw   t" << i << ", " << -(16 + 4 * (i+1)) << "(s0)\n";
    }

    // **核心修复：区分整型和浮点参数**
    int int_arg_idx = 0;
    int float_arg_idx = 0;
    for (unsigned i = 0; i < I.getNumArgOperands(); ++i) {
        llvm::Value* arg = I.getArgOperand(i);
        if (arg->getType()->isFloatTy()) {
            if (float_arg_idx < 8) {
                // 使用 loadFloatValueToReg 加载到浮点参数寄存器 faX
                loadFloatValueToReg(arg, "fa" + std::to_string(float_arg_idx));
            }
            float_arg_idx++;
        } else {
            if (int_arg_idx < 8) {
                // 使用 loadValueToReg 加载到整数参数寄存器 aX
                loadValueToReg(arg, "a" + std::to_string(int_arg_idx));
            }
            int_arg_idx++;
        }
    }

    out << "  call " << I.getCalledFunction()->getName().str() << "\n";

    // **恢复寄存器**
    out << "  # --- Restoring caller-saved registers after call ---\n";
    for (int i = 0; i <= 6; ++i) {
        out << "  lw   t" << i << ", " << -(16 + 4 * (i+1)) << "(s0)\n";
    }

    // If the call has a return value, it will be in a0. Store it to the stack location for this call instruction's result.
    if (!I.getType()->isVoidTy()) {
        if (I.getType()->isFloatTy()) {
            storeFloatRegToValue("fa0", &I); // **修复：从 fa0 获取浮点返回值**
        } else {
            storeRegToValue("a0", &I);
        }
    }
}

void RISCVCodeGenerator::visitICmpInst(llvm::ICmpInst& I) {
    loadValueToReg(I.getOperand(0), "t0");
    loadValueToReg(I.getOperand(1), "t1");

    // The result of ICmp is 0 or 1.
    // Strategy: Assume the result is 0, then set it to 1 if the condition is met.
    out << "  li   t2, 0\n"; 
    std::string condition_op;
    std::string skip_label = "." + current_function->getName().str() + "_skip" + std::to_string((intptr_t)&I);

    switch(I.getPredicate()) {
        case llvm::ICmpInst::ICMP_EQ:  condition_op = "bne"; break; // if not equal, skip setting to 1
        case llvm::ICmpInst::ICMP_NE:  condition_op = "beq"; break; // if equal, skip setting to 1
        case llvm::ICmpInst::ICMP_SLT: condition_op = "bge"; break; // if greater or equal, skip
        case llvm::ICmpInst::ICMP_SGT: condition_op = "ble"; break; // if less or equal, skip
        case llvm::ICmpInst::ICMP_SLE: condition_op = "bgt"; break; // if a > b, skip set to 1
        case llvm::ICmpInst::ICMP_SGE: condition_op = "blt"; break; // if a < b, skip set to 1
        // ... other comparisons
        default: condition_op = "unsupported_icmp"; break;
    }
    
    out << "  " << condition_op << " t0, t1, " << skip_label << "\n";
    out << "  li   t2, 1\n";
    out << skip_label << ":\n";

    storeRegToValue("t2", &I);
}

void RISCVCodeGenerator::visitGetElementPtrInst(llvm::GetElementPtrInst& I) {
    // 1. 获取基地址到 t0
    llvm::Value* BasePtr = I.getPointerOperand();
    loadAddressOfValueToReg(BasePtr, "t0");

    // 用 t3 来累加总的字节偏移量，初始为0
    out << "  li   t3, 0\n";

    const llvm::DataLayout& dl = current_function->getParent()->getDataLayout();
    llvm::Type* CurrentTy = BasePtr->getType();

    // 手动迭代 GEP
    for (unsigned i = 1; i < I.getNumOperands(); ++i) {
        llvm::Value* IdxValue = I.getOperand(i);

        if (auto* PtrTy = llvm::dyn_cast<llvm::PointerType>(CurrentTy)) {
            CurrentTy = PtrTy->getElementType();
        } else if (auto* ArrayTy = llvm::dyn_cast<llvm::ArrayType>(CurrentTy)) {
            CurrentTy = ArrayTy->getElementType();
        }

        uint64_t ElementSize = dl.getTypeAllocSize(CurrentTy);

        // 加载索引值到 t1
        loadValueToReg(IdxValue, "t1");
        
        // 计算当前维度的偏移
        if (ElementSize > 0) {
            out << "  li   t2, " << ElementSize << "\n";
            out << "  mul  t1, t1, t2\n"; // t1 = index * element_size
            out << "  add  t3, t3, t1\n"; // 累加到总偏移 t3
        }
    }

    // 将基地址和总偏移相加，得到最终地址
    out << "  add  t0, t0, t3\n";

    // 最终的地址在 t0 中，存入此 GEP 指令结果的栈位置
    storeRegToValue("t0", &I);
}

void RISCVCodeGenerator::visitPHINode(llvm::PHINode& I) {
    // PHI 指令的赋值逻辑在处理其前驱块的终结指令（如 br）时完成。
    // 所以这里什么都不用做。
}

void RISCVCodeGenerator::visitCastInst(llvm::CastInst& I) {
    llvm::Value* src = I.getOperand(0);
    
    // 对于 zext, sext, trunc 等大多数转换指令，
    // 我们只需要加载源操作数的值即可。
    // RISC-V的加载和算术指令通常会隐式处理扩展和截断。
    // 例如，从内存加载一个字节 (lb) 到一个32位寄存器，
    // 然后与另一个32位寄存器相加，这个过程就隐式地完成了扩展。
    // 所以，我们可以将 Cast 指令简化为一次移动/加载。
    
    loadValueToReg(src, "t0");
    storeRegToValue("t0", &I);
}

void RISCVCodeGenerator::visitFCmpInst(llvm::FCmpInst& I) {
    
    loadFloatValueToReg(I.getOperand(0), "ft0");
    loadFloatValueToReg(I.getOperand(1), "ft1");

    std::string condition_op;
    switch(I.getPredicate()) {
        case llvm::FCmpInst::FCMP_OEQ: condition_op = "feq.s"; break; // Ordered Equal
        case llvm::FCmpInst::FCMP_OLT: condition_op = "flt.s"; break; // Ordered Less Than
        case llvm::FCmpInst::FCMP_OLE: condition_op = "fle.s"; break; // Ordered Less or Equal
        // ... 添加 FCMP_OGT, FCMP_OGE, FCMP_ONE ...
        default:
             out << "  # ERROR: Unsupported FCmp predicate\n";
             storeRegToValue("zero", &I);
             return;
    }
    // 浮点比较的结果写入一个整数寄存器
    out << "  " << condition_op << " t2, ft0, ft1\n";
    storeRegToValue("t2", &I);
}

