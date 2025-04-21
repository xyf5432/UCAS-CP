#include <iostream>

// #include "antlr4-runtime.h"
#include "tree/ErrorNode.h"

#include "CACTLexer.h"
#include "CACTParser.h"
#include "CACTVisitor.h"

using namespace antlr4;

#define DEFAULT_VISIT(T) \
std::any visit##T(CACTParser::T##Context *ctx) override { \
    std::cout << "visit "#T << std::endl;\
    return visitChildren(ctx); \
}

class Analysis : public CACTVisitor {
public:
    /*std::any visitCompUnit(CACTParser::CompUnitContext *context) {
        visitChildren( context );
        
        //std::cout << "enter rule [r]!" << std::endl;
        //std::cout << "the ID is: " << context->ID()->getText().c_str() << std::endl;
        return nullptr;
    }*/

        // 语法入口规则
    DEFAULT_VISIT(CompUnit)     // 编译单元

    // 声明相关规则
    DEFAULT_VISIT(Decl)         // 声明（常量或变量）
    DEFAULT_VISIT(ConstDecl)    // 常量声明
    DEFAULT_VISIT(BType)        // 基本类型（int/float/char）
    DEFAULT_VISIT(ConstDef)     // 常量定义
    DEFAULT_VISIT(ConstInitVal) // 常量初始化
    DEFAULT_VISIT(VarDecl)      // 变量声明
    DEFAULT_VISIT(VarDef)       // 变量定义

    // 函数相关规则
    DEFAULT_VISIT(FuncDef)      // 函数定义
    DEFAULT_VISIT(FuncType)
    DEFAULT_VISIT(FuncFParams)  // 函数形参列表
    DEFAULT_VISIT(FuncFParam)   // 函数形参

    // 语句块与语句规则
    DEFAULT_VISIT(Block)        // 语句块
    DEFAULT_VISIT(BlockItem)    // 语句块项（声明或语句）
    DEFAULT_VISIT(AssignStmt)         // 语句（赋值/返回/条件等）

    DEFAULT_VISIT(ExprStmt)
    DEFAULT_VISIT(BlockStmt)
    DEFAULT_VISIT(ReturnStmt)
    DEFAULT_VISIT(IfStmt)
    DEFAULT_VISIT(WhileStmt)
    DEFAULT_VISIT(BreakStmt)
    DEFAULT_VISIT(ContinueStmt)

    // 表达式规则
    DEFAULT_VISIT(Exp)          // 基础表达式
    DEFAULT_VISIT(Cond)         // 条件表达式
    DEFAULT_VISIT(LVal)         // 左值（变量或数组元素）
    DEFAULT_VISIT(PrimaryExp)   // 基本表达式（括号/字面量/左值）
    DEFAULT_VISIT(PrimaryUnary)     // 单目运算表达式
    // 表达式运算相关规则
    DEFAULT_VISIT(UnaryOp)        // 单目运算符（如 +, -, !）
    DEFAULT_VISIT(FuncCall)       // 函数调用
    DEFAULT_VISIT(MulOp)          // 乘除模运算符（*, /, %）
    DEFAULT_VISIT(UnaryToMul)     // 单目表达式转乘法表达式
    DEFAULT_VISIT(MulToAdd)       // 乘法表达式转加法表达式
    DEFAULT_VISIT(AddOp)          // 加减运算符（+, -）
    DEFAULT_VISIT(AddToRel)       // 加法表达式转关系表达式
    DEFAULT_VISIT(RelOp)          // 关系运算符（<, >, <=, >=）
    DEFAULT_VISIT(EqOp)           // 相等性运算符（==, !=）
    DEFAULT_VISIT(RelToEq)        // 关系表达式转相等性表达式
    DEFAULT_VISIT(LAndOp)         // 逻辑与运算符（&&）
    DEFAULT_VISIT(EqToLAnd)       // 相等性表达式转逻辑与表达式
    DEFAULT_VISIT(LOrOp)          // 逻辑或运算符（||）
    DEFAULT_VISIT(LAndToLOr)      // 逻辑与表达式转逻辑或表达式

    // 函数参数与数值相关规则
    DEFAULT_VISIT(FuncRParams)    // 函数实参列表
    DEFAULT_VISIT(Number)         // 数值（整型/浮点型/字符型）
    DEFAULT_VISIT(ConstExp)       // 常量表达式

    std::any visitErrorNode(tree::ErrorNode * node) override {
        std::cout << "visit error node: " << node->getText() << std::endl;
        exit(1);
        return nullptr;
    }
};

int main(int argc, const char* argv[]) {
  //std::ifstream stream;
  //stream.open("../test/samples_lex_and_syntax/00_true_main.cact");
  std::ifstream stream(argv[1]);
  if (!stream.is_open()) {
    std::cout << "no such file!" << std::endl;
      return 1;
  }

  ANTLRInputStream   input(stream);
  CACTLexer         lexer(&input);
  CommonTokenStream  tokens(&lexer);
  CACTParser        parser(&tokens);

  Analysis visitor;
  visitor.visit( parser.compUnit() );

  return 0;
}
