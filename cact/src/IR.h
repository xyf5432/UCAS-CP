// IR.h
#pragma once
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include <llvm/Support/raw_ostream.h>  
#include <llvm/Support/FileSystem.h>   
#include "symboltable.h"
#include <stack>

struct LoopInfo {
    llvm::BasicBlock* condBB;
    llvm::BasicBlock* endBB;
};

class IRGenerator {
    std::unique_ptr<llvm::LLVMContext> contextPtr;  // 改为使用指针管理
    llvm::LLVMContext& context;  // 引用
    std::unique_ptr<llvm::Module> module;
    llvm::IRBuilder<> builder;
    
    std::stack<llvm::BasicBlock*> loopCondBBStack;
    std::stack<llvm::BasicBlock*> loopEndBBStack;

    std::stack<LoopInfo> loopStack;
    
public:
    IRGenerator();
    
    std::stack<llvm::BasicBlock*> blockStack;  // 基本块栈

    // 类型系统
    llvm::Type* getLLVMType(const SymType& type);

    llvm::Type* getLLVMType(std::string type);
    
    // 变量声明
    llvm::Value* generateVarDecl(const std::string& name, const SymType& type, llvm::Function* currentFunction = nullptr, llvm::Constant* initValue  = nullptr);
    
    // 函数定义
    llvm::Function* generateFunctionDef(const FunEntry& entry);
    void finalizeFunction(llvm::Function* function, llvm::Value* returnValue = nullptr);
    
    // 表达式生成
    llvm::Value* generateBinaryExpr(char op, llvm::Value* L, llvm::Value* R, const SymType& type);
    llvm::Value* generateArrayAccess(llvm::Value* arrayPtr, const std::vector<llvm::Value*>& indices, const SymType& arrayType);
    
    // 控制流
    void generateIfStmt(llvm::Value* cond, const std::function<void()>& thenGen, const std::function<void()>& elseGen = nullptr);
    void generateWhileLoop(const std::function<llvm::Value*()>& condGen, const std::function<void()>& bodyGen);

    llvm::Value* generateConstArrayInit(const SymType& arrayType, 
                                       const std::vector<llvm::Value*>& initValues);

    llvm::Value* getZeroValue(const std::string& typeName);

    llvm::BasicBlock* createBasicBlock(llvm::Function* function, const std::string& name);
    
    // 工具方法
    llvm::Module* getModule() { return module.get(); }
    llvm::LLVMContext& getContext() { return context; }
    llvm::IRBuilder<>& getBuilder() { return builder; }

    llvm::Function* getFunction(const std::string& name) {
        return module->getFunction(name);
    }

     void pushLoop(llvm::BasicBlock* condBB, llvm::BasicBlock* endBB) {
        loopStack.push({condBB, endBB});
    }
    
    void popLoop() {
        loopStack.pop();
    }
    
    LoopInfo getCurrentLoop() {
        if (loopStack.empty()) {
            throw std::runtime_error("No active loop");
        }
        return loopStack.top();
    }

    void dumpIRToFile(const std::string& filename) {
        std::error_code EC;
        llvm::raw_fd_ostream out(filename, EC);
        if (!EC) {
            module->print(out, nullptr);
        } else {
            std::cerr << "Error opening file for IR output: " << filename << std::endl;
        }
    }

    llvm::Value* generateFlatArrayInit(const SymType& arrayType, 
                                            const std::vector<llvm::Value*>& initValues, std::string Ident);
};