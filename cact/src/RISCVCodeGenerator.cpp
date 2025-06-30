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

void RISCVCodeGenerator::generate(llvm::Module* module, const std::string& filename) {
    out.open(filename);
    if (!out.is_open()) {
        std::cerr << "Error: Could not open output file " << filename << std::endl;
        return;
    }
    visitModule(module);
    out.close();
}

void RISCVCodeGenerator::processGlobals(llvm::Module* module) {
    out << ".data\n";
    for (const llvm::GlobalVariable& global : module->globals()) {
        out << global.getName().str() << ":\n";
        if (global.hasInitializer()) {
            const llvm::Constant* initializer = global.getInitializer();

            if (auto* CA = llvm::dyn_cast<llvm::ConstantArray>(initializer)) {
                // 处理常量数组
                for (unsigned i = 0; i < CA->getNumOperands(); ++i) {
                    if (auto* CI = llvm::dyn_cast<llvm::ConstantInt>(CA->getOperand(i))) {
                        // 假设数组元素是整数
                        out << "  .word " << CI->getSExtValue() << "\n";
                    } else if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(CA->getOperand(i))) {
                        // (扩展) 如果是浮点数组
                        // 注意：RISC-V的 .float 和 .double 可能需要特定处理
                        out << "  .float " << CF->getValueAPF().convertToFloat() << "\n";
                    }
                }
            } else if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(initializer)) {
                // --- 修复 `format_hex` ---
                llvm::APInt int_bits = CF->getValueAPF().bitcastToAPInt();
                std::stringstream ss;
                ss << "0x" << std::hex << int_bits.getZExtValue();
                out << "  .word " << ss.str() << "\n";

            } else if (auto* CDA = llvm::dyn_cast<llvm::ConstantDataArray>(initializer)) {
                // 处理更紧凑的常量数据数组 (例如 C 语言中的 const char a[] = "hello")
                if (CDA->isString()) {
                     out << "  .string \"" << CDA->getAsString().str() << "\"\n";
                } else { // 假设是整数或浮点数等基本类型
                    for (unsigned i = 0; i < CDA->getNumElements(); ++i) {
                         if (CDA->getElementType()->isIntegerTy()) {
                            out << "  .word " << CDA->getElementAsInteger(i) << "\n";
                         }
                    }
                }
            } else if (auto* CI = llvm::dyn_cast<llvm::ConstantInt>(initializer)) {
                // 处理单个整数
                out << "  .word " << CI->getSExtValue() << "\n";
            }
            // 你可以继续扩展以支持其他类型的全局常量...

        } else {
             // 未初始化的全局变量
            const llvm::DataLayout& dl = module->getDataLayout();
            uint64_t size = dl.getTypeAllocSize(global.getValueType());
            out << "  .zero " << size << "\n";
        }
    }
    out << "\n";
}

void RISCVCodeGenerator::loadAddressOfValueToReg(llvm::Value* value, const std::string& reg) {
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
    }

    for (llvm::Function& F : *module) {
        if (!F.isDeclaration()) {
            visitFunction(F);
        }
    }
}

void RISCVCodeGenerator::visitFunction(llvm::Function& F) {
    out << "\n" << F.getName().str() << ":\n";
    current_function = &F;
    epilogue_label = "." + F.getName().str() + "_epilogue";
    stack_offsets.clear();
    current_stack_size = 0;

    // --- Pass 1: Allocate stack space ---
    // Reserve space for return address and old frame pointer
    current_stack_size += 16;

    // --- 新增：为寄存器中转预留临时空间 ---
    // 比如预留 16 字节，足够放两个浮点数
    current_stack_size += 16;
    
    // Map Value to stack offset
    // Arguments are passed by register, but we still allocate backup space on the stack
    for (auto& arg : F.args()) {
        stack_offsets[&arg] = -current_stack_size;
        current_stack_size += 4; // Assume 4 bytes
    }

    const llvm::DataLayout& dl = F.getParent()->getDataLayout();
    for (llvm::BasicBlock& BB : F) {
        for (llvm::Instruction& I : BB) {
            // Case 1: Alloca instruction
            if (auto* allocaInst = llvm::dyn_cast<llvm::AllocaInst>(&I)) {
                // The "value" of the allocaInst is the address of this space
                stack_offsets[allocaInst] = -current_stack_size;
                current_stack_size += dl.getTypeAllocSize(allocaInst->getAllocatedType());
            } 
            // Case 2: Other instructions that produce a value
            else if (!I.getType()->isVoidTy()) {
                // Allocate a temporary storage location for the instruction's result
                stack_offsets[&I] = -current_stack_size;
                current_stack_size += 4; // Simplified to 4 bytes
            }
        }
    }
    
    // Align the stack frame to a 16-byte boundary
    if (current_stack_size % 16 != 0) {
        current_stack_size += 16 - (current_stack_size % 16);
    }
    
    // --- Pass 2: Generate code ---
    functionPrologue(F);

    for (llvm::BasicBlock& BB : F) {
        visitBasicBlock(BB);
    }
    
    // --- Generate the unified epilogue block ---
    out << epilogue_label << ":\n";
    functionEpilogue(F);
}

void RISCVCodeGenerator::visitBasicBlock(llvm::BasicBlock& BB) {
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
    out << "  sd   ra, " << (current_stack_size - 8) << "(sp)\n"; // Save return address
    out << "  sd   s0, " << (current_stack_size - 16) << "(sp)\n"; // Save old frame pointer
    out << "  addi s0, sp, " << current_stack_size << "\n"; // Set new frame pointer
    
    // Store function arguments from a0, a1, ... registers to the stack
    int arg_idx = 0;
    for (auto& arg : F.args()) {
        if (arg_idx < 8) { // First 8 RISC-V arguments are passed via a0-a7
            std::string reg_name = "a" + std::to_string(arg_idx);
            storeRegToValue(reg_name, &arg);
        }
        arg_idx++;
    }
}

void RISCVCodeGenerator::functionEpilogue(llvm::Function& F) {
    out << "  # Function Epilogue for " << F.getName().str() << "\n";
    out << "  ld   ra, " << (current_stack_size - 8) << "(sp)\n"; // Restore return address
    out << "  ld   s0, " << (current_stack_size - 16) << "(sp)\n"; // Restore old frame pointer
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
        // --- 修复 ---
        // 对 i1 类型的布尔值使用零扩展，其他整数使用符号扩展
        if (C->getType()->isIntegerTy(1)) {
             out << "  li   " << reg << ", " << C->getZExtValue() << "\n";
        } else {
             out << "  li   " << reg << ", " << C->getSExtValue() << "\n";
        }
    } else if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(value)) {
        // --- 修复 `format_hex` ---
        llvm::APInt int_val = CF->getValueAPF().bitcastToAPInt();
        std::stringstream ss;
        ss << "0x" << std::hex << int_val.getZExtValue();
        out << "  li   " << reg << ", " << ss.str() << "\n";
    } else {
        // 假设是栈上的值，直接从其地址加载
        out << "  lw   " << reg << ", " << getStackAddress(value) << "\n";
    }
}

void RISCVCodeGenerator::storeRegToValue(const std::string& reg, llvm::Value* value) {
    out << "  sw   " << reg << ", " << getStackAddress(value) << "\n";
}

// 将一个浮点值加载到指定的浮点寄存器 (e.g., "ft0")
void RISCVCodeGenerator::loadFloatValueToReg(llvm::Value* value, const std::string& reg) {
    if (auto* CF = llvm::dyn_cast<llvm::ConstantFP>(value)) {
        // 如果是常量，先加载到位模式到整数寄存器，然后通过栈中转
        std::string temp_reg = "t3"; // 使用一个临时整数寄存器
        llvm::APInt int_val = CF->getValueAPF().bitcastToAPInt();
        std::stringstream ss;
        ss << "0x" << std::hex << int_val.getZExtValue();

        // --- 修复：使用固定的临时栈槽 ---
        // 我们在栈帧顶部（靠近s0的地方）预留了空间，这里用-32(s0)
        std::string temp_slot = "-32(s0)";

        out << "  li   " << temp_reg << ", " << ss.str() << "\n";
        out << "  sw   " << temp_reg << ", " << temp_slot << "\n";
        out << "  flw  " << reg << ", " << temp_slot << "\n";
    } else {
        // 如果是变量，直接从它的栈位置加载
        out << "  flw  " << reg << ", " << getStackAddress(value) << "\n";
    }
}

// 将一个浮点寄存器 (e.g., "ft0") 的值存到一个Value对应的栈位置
void RISCVCodeGenerator::storeFloatRegToValue(const std::string& reg, llvm::Value* value) {
    out << "  fsw  " << reg << ", " << getStackAddress(value) << "\n";
}

// --- Instruction dispatcher ---
void RISCVCodeGenerator::visitInstruction(llvm::Instruction& I) {
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
    if (I.getReturnValue()) {
        // If there is a return value, load it into the a0 register
        loadValueToReg(I.getReturnValue(), "a0");
    }
    // Jump to the single function epilogue
    out << "  j    " << epilogue_label << "\n";
}

// RISCVCodeGenerator.cpp
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

    // 从 t0 指向的地址加载数据到 t1
    out << "  lw   t1, 0(t0)\n";
    
    // 将加载的值 t1 存到 load 指令本身结果的栈位置
    storeRegToValue("t1", &I);
}

void RISCVCodeGenerator::visitStoreInst(llvm::StoreInst& I) {
    llvm::Value* val = I.getValueOperand();
    llvm::Value* ptr = I.getPointerOperand();
    
    // 加载要存储的值到 t0
    loadValueToReg(val, "t0");

    // 加载目标地址指针的值（即地址本身）到 t1
    if (auto* alloca = llvm::dyn_cast<llvm::AllocaInst>(ptr)) {
        // 如果ptr是alloca，直接计算其地址
        out << "  addi t1, s0, " << stack_offsets[ptr] << "\n";
    } else if (auto* G = llvm::dyn_cast<llvm::GlobalValue>(ptr)) {
        out << "  la   t1, " << G->getName().str() << "\n";
    } else {
        // 如果ptr是其他指令的结果（例如GEP），
        // 它的值（地址）被存在它自己的栈槽里，需要先加载出来。
        loadValueToReg(ptr, "t1");
    }

    // 将 t0 的值存到 t1 指向的地址
    out << "  sw   t0, 0(t1)\n";
}

void RISCVCodeGenerator::visitBranchInst(llvm::BranchInst& I) {
    if (I.isConditional()) {
        llvm::BasicBlock* trueBB = I.getSuccessor(0);
        llvm::BasicBlock* falseBB = I.getSuccessor(1);

        // --- 处理 PHI 节点 ---
        // 在跳转到 trueBB 之前，处理其所有 phi 指令
        for (llvm::PHINode& phi : trueBB->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        
        // 在跳转到 falseBB 之前，处理其所有 phi 指令
        for (llvm::PHINode& phi : falseBB->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        
        // --- 生成跳转指令 ---
        loadValueToReg(I.getCondition(), "t0");
        std::string trueLabel = "." + trueBB->getParent()->getName().str() + "_" + trueBB->getName().str();
        std::string falseLabel = "." + falseBB->getParent()->getName().str() + "_" + falseBB->getName().str();
        out << "  bnez t0, " << trueLabel << "\n";
        out << "  j    " << falseLabel << "\n";

    } else { // 无条件跳转
        llvm::BasicBlock* destBB = I.getSuccessor(0);

        // --- 处理 PHI 节点 ---
        for (llvm::PHINode& phi : destBB->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        
        // --- 生成跳转指令 ---
        std::string destLabel = "." + destBB->getParent()->getName().str() + "_" + destBB->getName().str();
        out << "  j    " << destLabel << "\n";
    }
}

void RISCVCodeGenerator::visitCallInst(llvm::CallInst& I) {
    // Handle arguments
    int arg_idx = 0;
    for (unsigned i = 0; i < I.getNumArgOperands(); ++i) {
        if (arg_idx < 8) {
            loadValueToReg(I.getArgOperand(i), "a" + std::to_string(arg_idx));
        } else {
            // Arguments beyond 8 need to be pushed to the stack (simplified here, not implemented)
            out << "  # Argument " << arg_idx << " passed on stack (not implemented)\n";
        }
        arg_idx++;
    }

    out << "  call " << I.getCalledFunction()->getName().str() << "\n";

    // If the call has a return value, it will be in a0. Store it to the stack location for this call instruction's result.
    if (!I.getType()->isVoidTy()) {
        storeRegToValue("a0", &I);
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

    // 2. 遍历索引，累加偏移量
    // 使用 gep_type_iterator 的构造函数来创建迭代器
    // 注意：对于LLVM 10，我们需要从gep_type_begin(I)开始
    for (llvm::gep_type_iterator GTI = llvm::gep_type_begin(I),
                                 GTE = llvm::gep_type_end(I);
         GTI != GTE; ++GTI) {
        
        llvm::Value* IdxValue = GTI.getOperand();
        
        // 如果索引是0，通常没有偏移（除了某些特殊情况），但迭代器已经帮我们进入了下一层类型
        if (auto* CI = llvm::dyn_cast<llvm::ConstantInt>(IdxValue)) {
            if (CI->isZero()) {
                continue;
            }
        }
        
        const llvm::DataLayout& dl = current_function->getParent()->getDataLayout();
        
        if (GTI.isStruct()) {
            // (扩展) 结构体处理
            const llvm::StructLayout* SL = dl.getStructLayout(GTI.getStructType());
            
            // --- 修复部分 ---
            // 在LLVM 10中，我们直接从操作数获取索引值
            unsigned MemberIndex = llvm::cast<llvm::ConstantInt>(IdxValue)->getZExtValue();
            uint64_t MemberOffset = SL->getElementOffset(MemberIndex);
            
            // 对于结构体，偏移是固定的，直接加，而不是乘
            out << "  addi t0, t0, " << MemberOffset << "\n";
            continue; // 结构体处理完后直接进入下一次循环
        } else {
            // 数组处理
            uint64_t ElementSize = dl.getTypeAllocSize(GTI.getIndexedType());

            // 加载索引值到t1
            loadValueToReg(IdxValue, "t1");
        
            if (ElementSize > 0) {
                out << "  li   t2, " << ElementSize << "\n";
                out << "  mul  t1, t1, t2\n";
                out << "  add  t0, t0, t1\n";
            }
        }
    }

    // 3. 最终的地址在 t0 中，存入此 GEP 指令结果的栈位置
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