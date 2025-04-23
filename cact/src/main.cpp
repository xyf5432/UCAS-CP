#include <iostream>

#include "antlr4-runtime.h"
#include "tree/ErrorNode.h"

#include "CACTLexer.h"
#include "CACTParser.h"
#include "CACTVisitor.h"

using namespace antlr4;

class Analysis : public CACTVisitor {
public:

    // 语法入口规则
    std::any visitCompUnit(CACTParser::CompUnitContext *ctx) override {
        std::cout << "visit CompUnit" << std::endl;
        return visitChildren(ctx);
    }

    // 声明相关规则
    std::any visitDecl(CACTParser::DeclContext *ctx) override {
        std::cout << "visit Decl" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitConstDecl(CACTParser::ConstDeclContext *ctx) override {
        std::cout << "visit ConstDecl" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitBType(CACTParser::BTypeContext *ctx) override {
        std::cout << "visit BType : " << ctx->getText() << std::endl;
        return visitChildren(ctx);
    }

    std::any visitConstDef(CACTParser::ConstDefContext *ctx) override {
        std::cout << "visit ConstDef" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitConstInitVal(CACTParser::ConstInitValContext *ctx) override {
        std::cout << "visit ConstInitVal" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitVarDecl(CACTParser::VarDeclContext *ctx) override {
        std::cout << "visit VarDecl" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitVarDef(CACTParser::VarDefContext *ctx) override {
        std::cout << "visit VarDef" << std::endl;
        return visitChildren(ctx);
    }

    // 函数相关规则
    std::any visitFuncDef(CACTParser::FuncDefContext *ctx) override {
        std::cout << "visit FuncDef" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitFuncType(CACTParser::FuncTypeContext *ctx) override {
        std::cout << "visit FuncType : " << ctx->getText() << std::endl;
        return visitChildren(ctx);
    }

    std::any visitFuncFParams(CACTParser::FuncFParamsContext *ctx) override {
        std::cout << "visit FuncFParams" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitFuncFParam(CACTParser::FuncFParamContext *ctx) override {
        std::cout << "visit FuncFParam" << std::endl;
        return visitChildren(ctx);
    }

    // 语句块与语句规则
    std::any visitBlock(CACTParser::BlockContext *ctx) override {
        std::cout << "visit Block" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitBlockItem(CACTParser::BlockItemContext *ctx) override {
        std::cout << "visit BlockItem" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitAssignStmt(CACTParser::AssignStmtContext *ctx) override {
        std::cout << "visit AssignStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitExprStmt(CACTParser::ExprStmtContext *ctx) override {
        std::cout << "visit ExprStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitBlockStmt(CACTParser::BlockStmtContext *ctx) override {
        std::cout << "visit BlockStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitReturnStmt(CACTParser::ReturnStmtContext *ctx) override {
        std::cout << "visit ReturnStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitIfStmt(CACTParser::IfStmtContext *ctx) override {
        std::cout << "visit IfStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitWhileStmt(CACTParser::WhileStmtContext *ctx) override {
        std::cout << "visit WhileStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitBreakStmt(CACTParser::BreakStmtContext *ctx) override {
        std::cout << "visit BreakStmt" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitContinueStmt(CACTParser::ContinueStmtContext *ctx) override {
        std::cout << "visit ContinueStmt" << std::endl;
        return visitChildren(ctx);
    }

    // 表达式规则
    std::any visitExp(CACTParser::ExpContext *ctx) override {
        std::cout << "visit Exp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitCond(CACTParser::CondContext *ctx) override {
        std::cout << "visit Cond" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitLVal(CACTParser::LValContext *ctx) override {
        std::cout << "visit LVal" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitPrimaryExp(CACTParser::PrimaryExpContext *ctx) override {
        std::cout << "visit PrimaryExp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitPrimaryUnary(CACTParser::PrimaryUnaryContext *ctx) override {
        std::cout << "visit PrimaryUnary" << std::endl;
        return visitChildren(ctx);
    }

    // 表达式运算相关规则
    std::any visitUnaryOp(CACTParser::UnaryOpContext *ctx) override {
        std::cout << "visit UnaryOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitFuncCall(CACTParser::FuncCallContext *ctx) override {
        std::cout << "visit FuncCall" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitMulOp(CACTParser::MulOpContext *ctx) override {
        std::cout << "visit MulOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitUnaryToMul(CACTParser::UnaryToMulContext *ctx) override {
        std::cout << "visit UnaryToMul" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitMulToAdd(CACTParser::MulToAddContext *ctx) override {
        std::cout << "visit MulToAdd" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitAddOp(CACTParser::AddOpContext *ctx) override {
        std::cout << "visit AddOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitAddToRel(CACTParser::AddToRelContext *ctx) override {
        std::cout << "visit AddToRel" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitRelOp(CACTParser::RelOpContext *ctx) override {
        std::cout << "visit RelOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitEqOp(CACTParser::EqOpContext *ctx) override {
        std::cout << "visit EqOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitRelToEq(CACTParser::RelToEqContext *ctx) override {
        std::cout << "visit RelToEq" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitLAndOp(CACTParser::LAndOpContext *ctx) override {
        std::cout << "visit LAndOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitEqToLAnd(CACTParser::EqToLAndContext *ctx) override {
        std::cout << "visit EqToLAnd" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitLOrOp(CACTParser::LOrOpContext *ctx) override {
        std::cout << "visit LOrOp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitLAndToLOr(CACTParser::LAndToLOrContext *ctx) override {
        std::cout << "visit LAndToLOr" << std::endl;
        return visitChildren(ctx);
    }

    // 函数参数与数值相关规则
    std::any visitFuncRParams(CACTParser::FuncRParamsContext *ctx) override {
        std::cout << "visit FuncRParams" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitNumber(CACTParser::NumberContext *ctx) override {
        std::cout << "visit Number" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitConstExp(CACTParser::ConstExpContext *ctx) override {
        std::cout << "visit ConstExp" << std::endl;
        return visitChildren(ctx);
    }

    std::any visitErrorNode(tree::ErrorNode * node) override {
        std::cout << "visit error node: " << node->getText() << std::endl;
        exit(1);
        return nullptr;
    }
};

class MyErrorListener : public BaseErrorListener {
    public:
        void syntaxError(Recognizer *recognizer, Token *offendingSymbol,
                         size_t line, size_t charPosInLine,
                         const std::string &msg, std::exception_ptr e) override {
            std::cerr << "语法错误：第 " << line << " 行，第 " << charPosInLine
                      << " 列：" << msg << std::endl;
            exit(1); // 出错就终止程序
        }
    };

    

int main(int argc, const char* argv[]) {
  std::ifstream stream(argv[1]);
  if (!stream.is_open()) {
    std::cout << "no such file!" << std::endl;
      return 1;
  }

  ANTLRInputStream   input(stream);
  CACTLexer         lexer(&input);
  CommonTokenStream  tokens(&lexer);
  CACTParser        parser(&tokens);

  // 替换默认错误监听器
parser.removeErrorListeners(); // 清除默认控制台打印
parser.addErrorListener(new MyErrorListener()); // 添加自定义监听器

  Analysis visitor;
  visitor.visit( parser.compUnit() );

  return 0;
}

