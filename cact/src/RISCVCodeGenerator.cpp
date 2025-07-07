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
    out << "\n" << F.getName().str() << ":\n";
    current_function = &F;
    epilogue_label = "." + F.getName().str() + "_epilogue";
    stack_offsets.clear();
    
    // --- Pass 1: Allocate stack space ---
    
    // **修改：为 ra/s0 和 caller-saved 寄存器暂存区预留空间**
    int local_var_offset = 0;
    int caller_saved_area_size = 32; // 为 t0-t6 (28字节) 预留32字节
    local_var_offset -= 16; // ra/s0 的空间
    local_var_offset -= caller_saved_area_size; // 调用者保存寄存器的暂存区

    // **核心修复：为函数参数分配栈上备份空间**
    const llvm::DataLayout& dl = F.getParent()->getDataLayout();
    for (auto& arg : F.args()) {
        uint64_t size = dl.getTypeAllocSize(arg.getType());
        local_var_offset -= size;
        stack_offsets[&arg] = local_var_offset; // 将参数arg映射到它的栈偏移
    }

    // 遍历所有指令，计算局部变量和临时值所需的总空间
    for (llvm::BasicBlock& BB : F) {
        for (llvm::Instruction& I : BB) {
            if (auto* allocaInst = llvm::dyn_cast<llvm::AllocaInst>(&I)) {
                // alloca 指令的值就是地址，所以它的偏移就是它所分配空间顶部的地址
                uint64_t size = dl.getTypeAllocSize(allocaInst->getAllocatedType());
                local_var_offset -= size; 
                stack_offsets[allocaInst] = local_var_offset;
            } 
            else if (!I.getType()->isVoidTy()) {
                // 为指令结果分配临时空间
                // 假设所有临时结果大小为4字节（需要根据类型调整）
                // 更好的做法是: local_var_offset -= dl.getTypeAllocSize(I.getType());
                local_var_offset -= 4; 
                stack_offsets[&I] = local_var_offset;
            }
        }
    }

    // 计算最终的栈帧大小
    current_stack_size = -local_var_offset;
    
    // Align the stack frame to a 16-byte boundary
    if (current_stack_size % 16 != 0) {
        current_stack_size += 16 - (current_stack_size % 16);
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
        // ... 对浮点常量的加载也需要应用同样的逻辑 ...
        std::string temp_reg = "t3";
        llvm::APInt int_val = CF->getValueAPF().bitcastToAPInt();
        long long val = int_val.getZExtValue();
        
        int low12 = val & 0xFFF;
        if (low12 & 0x800) {
            low12 -= 0x1000;
        }
        int high20 = (val - low12) >> 12;

        std::string temp_slot = "-32(s0)"; // 或者其他预留的临时槽

        if (low12 == 0) {
            out << "  lui  " << temp_reg << ", " << high20 << "\n";
        } else {
            out << "  lui  " << temp_reg << ", " << high20 << "\n";
            out << "  addi " << temp_reg << ", " << temp_reg << ", " << low12 << "\n";
        }
        
        out << "  sw   " << temp_reg << ", " << temp_slot << "\n";
        out << "  lw  " << reg << ", " << temp_slot << "\n";

    } else {
        // 从栈或全局变量加载
        out << "  lw   " << reg << ", " << getStackAddress(value) << "\n";
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
        out << "  flw  ft0, 0(t0)\n";       // 使用 flw 加载浮点数
        storeFloatRegToValue("ft0", &I); // 存到浮点结果
    } else {
        out << "  lw   t1, 0(t0)\n";         // 使用 lw 加载整数
        storeRegToValue("t1", &I);      // 存到整数结果
    }
}

void RISCVCodeGenerator::visitStoreInst(llvm::StoreInst& I) {
    llvm::Value* val = I.getValueOperand();
    llvm::Value* ptr = I.getPointerOperand();
    bool isFloat = val->getType()->isFloatTy();
    
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
    if (isFloat) {
        // --- 浮点数存储 ---
        loadFloatValueToReg(val, "ft0"); // 将要存储的浮点值加载到浮点寄存器
        out << "  fsw  ft0, 0(t1)\n";     // 使用 fsw 存储
    } else {
        // --- 整数存储 ---
        loadValueToReg(val, "t0");       // 将要存储的整数值加载到整数寄存器
        out << "  sw   t0, 0(t1)\n";       // 使用 sw 存储
    }
}

void RISCVCodeGenerator::visitBranchInst(llvm::BranchInst& I) {
    if (I.isConditional()) {
        llvm::Value* cond = I.getCondition();
        llvm::BasicBlock* trueDest = I.getSuccessor(0);
        llvm::BasicBlock* falseDest = I.getSuccessor(1);
        std::string trueLabel = "." + trueDest->getParent()->getName().str() + "_" + trueDest->getName().str();
        std::string falseLabel = "." + falseDest->getParent()->getName().str() + "_" + falseDest->getName().str();
        std::string false_phi_label = "." + current_function->getName().str() + "_phi_false" + std::to_string((intptr_t)&I);
        std::string end_label = "." + current_function->getName().str() + "_br_end" + std::to_string((intptr_t)&I);

        loadValueToReg(cond, "t0");
        out << "  beqz t0, " << false_phi_label << "\n";

        // --- True Path ---
        // 为 trueDest 的 phi 节点赋值
        for (llvm::PHINode& phi : trueDest->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        out << "  j " << trueLabel << "\n";
        
        // --- False Path ---
        out << false_phi_label << ":\n";
        // 为 falseDest 的 phi 节点赋值
        for (llvm::PHINode& phi : falseDest->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        out << "  j " << falseLabel << "\n";

    } else {
        // 无条件跳转逻辑不变
        llvm::BasicBlock* dest = I.getSuccessor(0);
        for (llvm::PHINode& phi : dest->phis()) {
            llvm::Value* incomingVal = phi.getIncomingValueForBlock(I.getParent());
            loadValueToReg(incomingVal, "t2");
            storeRegToValue("t2", &phi);
        }
        std::string destLabel = "." + dest->getParent()->getName().str() + "_" + dest->getName().str();
        out << "  j    " << destLabel << "\n";
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

