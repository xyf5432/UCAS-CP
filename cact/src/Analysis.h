// Analysis.h
#pragma once

#include "CACTLexer.h"
#include "CACTParser.h"
#include "CACTVisitor.h"
#include "IR.h"
#include "llvm/IR/Verifier.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include <stack>
#include <memory>

using namespace antlr4;

class Analysis : public CACTVisitor {
private:
    // IR生成器
    std::unique_ptr<llvm::LLVMContext> context;
    std::unique_ptr<IRGenerator> irGen;
    
    // 符号表相关
    SymbolTable* globalTable;
    SymbolTable* current;
    
    // 类型系统
    SymType Bool;
    
    // 函数上下文管理
    std::stack<std::string> current_funname;
    std::stack<FunType> current_rettype;
    
    // 控制流状态
    int inLoop;
    int return_exist;

    // 初始化内置函数
    void initBuiltinFunctions();
    
    // 多维数组初始化检查
    bool checkMultiDimInit(const SymType& arrayType, 
                         CACTParser::ConstInitValContext* ctx, 
                         size_t dimIndex);

    void generateNestedArrayInit(
        const SymType& arrayType,
        CACTParser::ConstInitValContext* ctx,
        std::vector<llvm::Constant*>& initValues,
        size_t dimIndex
    );

    llvm::Constant* createNestedArrayInitializer(llvm::Type* elemType, 
                                           const std::vector<int>& dims,
                                           const std::vector<llvm::Constant*>& flatValues,
                                           size_t startIndex = 0,
                                           size_t currentDim = 0);

    void fillMultiDimInit(const SymType& arrayType,
                               CACTParser::ConstInitValContext* ctx,
                               llvm::Value* arrayPtr,
                               size_t dimIndex,
                               std::vector<llvm::Value*>& indices);

public:
    Analysis();
    ~Analysis();

    // 访问者接口实现
    std::any visitCompUnit(CACTParser::CompUnitContext *ctx) override;
    std::any visitDecl(CACTParser::DeclContext *ctx) override;
    std::any visitConstDecl(CACTParser::ConstDeclContext *ctx) override;
    std::any visitBType(CACTParser::BTypeContext *ctx) override;
    std::any visitConstDef(CACTParser::ConstDefContext *ctx) override;
    std::any visitConstInitVal(CACTParser::ConstInitValContext *ctx) override;
    std::any visitVarDecl(CACTParser::VarDeclContext *ctx) override;
    std::any visitVarDef(CACTParser::VarDefContext *ctx) override;
    std::any visitFuncDef(CACTParser::FuncDefContext *ctx) override;
    std::any visitFuncType(CACTParser::FuncTypeContext *ctx) override;
    std::any visitFuncFParams(CACTParser::FuncFParamsContext *ctx) override;
    std::any visitFuncFParam(CACTParser::FuncFParamContext *ctx) override;
    std::any visitBlock(CACTParser::BlockContext *ctx) override;
    std::any visitBlockItem(CACTParser::BlockItemContext *ctx) override;
    std::any visitStmt(CACTParser::StmtContext *ctx) override;
    std::any visitExp(CACTParser::ExpContext *ctx) override;
    std::any visitConstExp(CACTParser::ConstExpContext *ctx) override;
    std::any visitCond(CACTParser::CondContext *ctx) override;
    std::any visitLVal(CACTParser::LValContext *ctx) override;
    std::any visitNumber(CACTParser::NumberContext *ctx) override;
    std::any visitFuncRParams(CACTParser::FuncRParamsContext *ctx) override;
    std::any visitPrimaryExp(CACTParser::PrimaryExpContext *ctx) override;
    std::any visitUnaryExp(CACTParser::UnaryExpContext *ctx) override;
    std::any visitMulExp(CACTParser::MulExpContext *ctx) override;
    std::any visitAddExp(CACTParser::AddExpContext *ctx) override;
    std::any visitRelExp(CACTParser::RelExpContext *ctx) override;
    std::any visitEqExp(CACTParser::EqExpContext *ctx) override;
    std::any visitLAndExp(CACTParser::LAndExpContext *ctx) override;
    std::any visitLOrExp(CACTParser::LOrExpContext *ctx) override;
    std::any visitErrorNode(tree::ErrorNode *node) override;

    // 工具方法
    IRGenerator& getIRGenerator() { return *irGen; }
};