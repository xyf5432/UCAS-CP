// RISCVCodeGenerator.h
#pragma once

#include "llvm/IR/Module.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/raw_ostream.h"
#include <fstream>
#include <map>
#include <string>

class RISCVCodeGenerator {
public:
    // 公共入口函数
    void generate(llvm::Module* module, const std::string& filename);

private:
    // 主要的遍历函数
    void visitModule(llvm::Module* module);
    void visitFunction(llvm::Function& function);
    void visitBasicBlock(llvm::BasicBlock& block);
    void emitConstant(std::ofstream& out, const llvm::Constant* C);
    
    // 指令分发器
    void visitInstruction(llvm::Instruction& instr);

    // 具体的指令翻译函数
    void visitReturnInst(llvm::ReturnInst& inst);
    void visitBinaryOperator(llvm::BinaryOperator& inst);
    void visitAllocaInst(llvm::AllocaInst& inst);
    void visitLoadInst(llvm::LoadInst& inst);
    void visitStoreInst(llvm::StoreInst& inst);
    void visitBranchInst(llvm::BranchInst& inst);
    void visitCallInst(llvm::CallInst& inst);
    void visitICmpInst(llvm::ICmpInst& inst);
    void visitGetElementPtrInst(llvm::GetElementPtrInst& inst);
    void visitPHINode(llvm::PHINode& inst); 
    void visitCastInst(llvm::CastInst& inst);
    void visitFCmpInst(llvm::FCmpInst& I);
    // ... 可以继续添加 FCmpInst, PHINode 等

    // 辅助函数
    void functionPrologue(llvm::Function& F);
    void functionEpilogue(llvm::Function& F);
    void processGlobals(llvm::Module* module);
    void loadAddressOfValueToReg(llvm::Value* value, const std::string& reg);

    // 获取 Value 在栈上的地址字符串，例如 "-8(s0)"
    std::string getStackAddress(llvm::Value* value);
    // 将一个 Value 从栈加载到指定的寄存器
    void loadValueToReg(llvm::Value* value, const std::string& reg);
    // 将一个寄存器中的值存储到 Value 对应的栈位置
    void storeRegToValue(const std::string& reg, llvm::Value* value);
    void loadFloatValueToReg(llvm::Value* value, const std::string& reg);
    void storeFloatRegToValue(const std::string& reg, llvm::Value* value);


    std::ofstream out; // 输出文件流

    // 核心数据结构：将 LLVM Value 映射到其在栈帧上的偏移量
    // 使用 s0(fp) 作为帧指针
    std::map<llvm::Value*, int> stack_offsets;
    int current_stack_size;
    llvm::Function* current_function; // 指向当前正在处理的函数
    std::string epilogue_label;       // Label for the unified function epilogue
    llvm::Module* current_module;
};