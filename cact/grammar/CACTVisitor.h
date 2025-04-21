
    #include <vector>


// Generated from CACT.g4 by ANTLR 4.13.1

#pragma once


#include "antlr4-runtime.h"
#include "CACTParser.h"



/**
 * This class defines an abstract visitor for a parse tree
 * produced by CACTParser.
 */
class  CACTVisitor : public antlr4::tree::AbstractParseTreeVisitor {
public:

  /**
   * Visit parse trees produced by CACTParser.
   */
    virtual std::any visitCompUnit(CACTParser::CompUnitContext *context) = 0;

    virtual std::any visitDecl(CACTParser::DeclContext *context) = 0;

    virtual std::any visitConstDecl(CACTParser::ConstDeclContext *context) = 0;

    virtual std::any visitBType(CACTParser::BTypeContext *context) = 0;

    virtual std::any visitConstDef(CACTParser::ConstDefContext *context) = 0;

    virtual std::any visitConstInitVal(CACTParser::ConstInitValContext *context) = 0;

    virtual std::any visitVarDecl(CACTParser::VarDeclContext *context) = 0;

    virtual std::any visitVarDef(CACTParser::VarDefContext *context) = 0;

    virtual std::any visitFuncDef(CACTParser::FuncDefContext *context) = 0;

    virtual std::any visitFuncType(CACTParser::FuncTypeContext *context) = 0;

    virtual std::any visitFuncFParams(CACTParser::FuncFParamsContext *context) = 0;

    virtual std::any visitFuncFParam(CACTParser::FuncFParamContext *context) = 0;

    virtual std::any visitBlock(CACTParser::BlockContext *context) = 0;

    virtual std::any visitBlockItem(CACTParser::BlockItemContext *context) = 0;

    virtual std::any visitAssignStmt(CACTParser::AssignStmtContext *context) = 0;

    virtual std::any visitExprStmt(CACTParser::ExprStmtContext *context) = 0;

    virtual std::any visitBlockStmt(CACTParser::BlockStmtContext *context) = 0;

    virtual std::any visitReturnStmt(CACTParser::ReturnStmtContext *context) = 0;

    virtual std::any visitIfStmt(CACTParser::IfStmtContext *context) = 0;

    virtual std::any visitWhileStmt(CACTParser::WhileStmtContext *context) = 0;

    virtual std::any visitBreakStmt(CACTParser::BreakStmtContext *context) = 0;

    virtual std::any visitContinueStmt(CACTParser::ContinueStmtContext *context) = 0;

    virtual std::any visitExp(CACTParser::ExpContext *context) = 0;

    virtual std::any visitConstExp(CACTParser::ConstExpContext *context) = 0;

    virtual std::any visitCond(CACTParser::CondContext *context) = 0;

    virtual std::any visitLVal(CACTParser::LValContext *context) = 0;

    virtual std::any visitNumber(CACTParser::NumberContext *context) = 0;

    virtual std::any visitFuncRParams(CACTParser::FuncRParamsContext *context) = 0;

    virtual std::any visitPrimaryExp(CACTParser::PrimaryExpContext *context) = 0;

    virtual std::any visitPrimaryUnary(CACTParser::PrimaryUnaryContext *context) = 0;

    virtual std::any visitUnaryOp(CACTParser::UnaryOpContext *context) = 0;

    virtual std::any visitFuncCall(CACTParser::FuncCallContext *context) = 0;

    virtual std::any visitMulOp(CACTParser::MulOpContext *context) = 0;

    virtual std::any visitUnaryToMul(CACTParser::UnaryToMulContext *context) = 0;

    virtual std::any visitMulToAdd(CACTParser::MulToAddContext *context) = 0;

    virtual std::any visitAddOp(CACTParser::AddOpContext *context) = 0;

    virtual std::any visitAddToRel(CACTParser::AddToRelContext *context) = 0;

    virtual std::any visitRelOp(CACTParser::RelOpContext *context) = 0;

    virtual std::any visitEqOp(CACTParser::EqOpContext *context) = 0;

    virtual std::any visitRelToEq(CACTParser::RelToEqContext *context) = 0;

    virtual std::any visitLAndOp(CACTParser::LAndOpContext *context) = 0;

    virtual std::any visitEqToLAnd(CACTParser::EqToLAndContext *context) = 0;

    virtual std::any visitLOrOp(CACTParser::LOrOpContext *context) = 0;

    virtual std::any visitLAndToLOr(CACTParser::LAndToLOrContext *context) = 0;


};

