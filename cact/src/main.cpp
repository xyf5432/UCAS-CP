#include <iostream>

// #include "antlr4-runtime.h"
#include "tree/ErrorNode.h"

#include "CACTLexer.h"
#include "CACTParser.h"
#include "CACTVisitor.h"
#include "symboltable.h"

using namespace antlr4;

class Analysis : public CACTVisitor {
public:
    SymbolTable* globalTable = new SymbolTable();
    SymbolTable* current = globalTable;
    enum define_type {SYM,FUN}; // 声明类型暂存
    define_type define_type;

    // 语法入口规则
    std::any visitCompUnit(CACTParser::CompUnitContext *ctx) override {
        std::cout << "visit CompUnit" << std::endl;
        return visitChildren(ctx);
    }

    // 声明相关规则
    std::any visitDecl(CACTParser::DeclContext *ctx) override {
        std::cout << "visit Decl" << std::endl;
        define_type = SYM;
        return visitChildren(ctx);
    }

    std::any visitConstDecl(CACTParser::ConstDeclContext *ctx) override {
        std::cout << "visit ConstDecl" << std::endl;
        auto result = visitChildren(ctx);
        SymType SymType;
        SymType.base_type = ctx->bType()->getText();
        SymType.is_const = true;
        std::vector<int> array_dims;
        
        // 遍历所有ConstDef，获取每个的Ident
        for (auto constDefCtx : ctx->constDef()) {
            std::string Ident = constDefCtx->Ident()->getText();
            for (auto intconstctx : constDefCtx->IntConst()) {
                // 将字符串维度值转换为整数（例如 "5" → 5）
                int dim = std::stoi(intconstctx->getText());
                array_dims.push_back(dim);
            }

            if (!array_dims.empty()) {
                SymType.is_array = true;
                SymType.array_dims = array_dims;
            } else {
                SymType.is_array = false;
            }
            
            // 这里可以处理每个Ident和BType的关系，例如存入符号表
            current->insertsym(Ident,SymType);
            std::cout << "ConstDef Ident: " << Ident << ", Type: " << SymType.is_array << SymType.base_type << std::endl;
        }
        return result;
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
        auto result = visitChildren(ctx);
        SymType SymType;
        SymType.base_type = ctx->bType()->getText();
        SymType.is_const = false;
        std::vector<int> array_dims;

        // 遍历所有varDef，获取每个的Ident
        for (auto varDefCtx : ctx->varDef()) {
            std::string Ident = varDefCtx->Ident()->getText();
            for (auto intconstctx : varDefCtx->IntConst()) {
                // 将字符串维度值转换为整数（例如 "5" → 5）
                int dim = std::stoi(intconstctx->getText());
                array_dims.push_back(dim);
            }

            if (!array_dims.empty()) {
                SymType.is_array = true;
                SymType.array_dims = array_dims;
            } else {
                SymType.is_array = false;
            }

            // 这里可以处理每个Ident和BType的关系，例如存入符号表
            current->insertsym(Ident,SymType);
            std::cout << "varDef Ident: " << Ident << ", Type: " << SymType.is_array << SymType.base_type << std::endl;
        }
        return result;
    }

    std::any visitVarDef(CACTParser::VarDefContext *ctx) override {
        std::cout << "visit VarDef" << std::endl;
        return visitChildren(ctx);
    }

    // 函数相关规则
    std::any visitFuncDef(CACTParser::FuncDefContext *ctx) override {
        std::cout << "visit FuncDef" << std::endl;
        define_type = FUN;
        auto result = visitChildren(ctx);
        FunType FunType;
        FunType = stringToFunType(ctx->funcType()->getText());
        // 获取name
        std::string name = ctx->Ident()->getText();
        // 获取params
        std::vector<std::string> params_name;
        std::vector<SymType> params_type;
        if (auto paramsCtx = ctx->funcFParams()) {
            for (auto paramCtx : paramsCtx->funcFParam()) {
                // 获取参数类型
                SymType paramType;
                std::string paramBType = paramCtx->bType()->getText();
                paramType.base_type = paramBType;
                paramType.is_const = false;
                std::vector<int> array_dims;
                if (paramCtx->getText().find("[]")!=-1)
                {
                    array_dims.push_back(-1);
                }

                for (auto intconstctx : paramCtx->IntConst()) {
                    // 将字符串维度值转换为整数（例如 "5" → 5）
                    int dim = std::stoi(intconstctx->getText());
                    array_dims.push_back(dim);
                }
    
                if (!array_dims.empty()) {
                    paramType.is_array = true;
                    paramType.array_dims = array_dims;
                } else {
                    paramType.is_array = false;
                }
                
                // 这里可以处理每个Ident和BType的关系，例如存入符号表
                std::string Ident = paramCtx->Ident()->getText();
                params_name.push_back(Ident);
                params_type.push_back(paramType);
                std::cout << "params Ident: " << Ident << ", Type: " << paramType.is_array << paramType.base_type << std::endl;
            }
        }
        // 存入符号表
        current->insertfun(name,FunType,params_name,params_type);
        std::cout << "FunDef Ident: " << name << ", Type: " << ctx->funcType()->getText() << std::endl;
        return result;
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
        current = current->enterScope();
        //将函数参数加入符号表
        if (dynamic_cast<CACTParser::FuncDefContext*>(ctx->parent)!=nullptr)
        {
            auto* func_def = dynamic_cast<CACTParser::FuncDefContext*>(ctx->parent);
            if (func_def->funcFParams()) {
                for (auto param : func_def->funcFParams()->funcFParam()) {
                    // 解析参数类型
                    SymType type;
                    type.base_type = param->bType()->getText();
                    type.is_const = false; // 函数参数默认不可为 const
        
                    std::vector<int> array_dims;
                    if (param->getText().find("[]")!=-1)
                    {
                        array_dims.push_back(-1);
                    }

                    for (auto intconstctx : param->IntConst()) {
                        // 将字符串维度值转换为整数（例如 "5" → 5）
                        int dim = std::stoi(intconstctx->getText());
                        array_dims.push_back(dim);
                    }
        
                    if (!array_dims.empty()) {
                        type.is_array = true;
                        type.array_dims = array_dims;
                    } else {
                        type.is_array = false;
                    }

                    std::string Ident = param->Ident()->getText();
                    current->insertsym(Ident,type);
                }
            }
        }
        
        std::cout << "visit Block" << std::endl;
        auto result = visitChildren(ctx);
        current->print();
        SymbolTable* temp = current;
        current = current->parent;
        delete temp;
        return result;
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

  Analysis visitor;
  visitor.visit( parser.compUnit() );
  return 0;
}