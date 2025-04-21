
    #include <vector>


// Generated from CACT.g4 by ANTLR 4.13.1

#pragma once


#include "antlr4-runtime.h"
#include "CACTVisitor.h"


/**
 * This class provides an empty implementation of CACTVisitor, which can be
 * extended to create a visitor which only needs to handle a subset of the available methods.
 */
class  CACTBaseVisitor : public CACTVisitor {
public:

  virtual std::any visitCompUnit(CACTParser::CompUnitContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitDecl(CACTParser::DeclContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstDecl(CACTParser::ConstDeclContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBType(CACTParser::BTypeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstDef(CACTParser::ConstDefContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstInitVal(CACTParser::ConstInitValContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitVarDecl(CACTParser::VarDeclContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitVarDef(CACTParser::VarDefContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitFuncDef(CACTParser::FuncDefContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitFuncType(CACTParser::FuncTypeContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitFuncFParams(CACTParser::FuncFParamsContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitFuncFParam(CACTParser::FuncFParamContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBlock(CACTParser::BlockContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBlockItem(CACTParser::BlockItemContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitAssignStmt(CACTParser::AssignStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitExprStmt(CACTParser::ExprStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBlockStmt(CACTParser::BlockStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitReturnStmt(CACTParser::ReturnStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitIfStmt(CACTParser::IfStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitWhileStmt(CACTParser::WhileStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitBreakStmt(CACTParser::BreakStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitContinueStmt(CACTParser::ContinueStmtContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitExp(CACTParser::ExpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitConstExp(CACTParser::ConstExpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitCond(CACTParser::CondContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitLVal(CACTParser::LValContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitNumber(CACTParser::NumberContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitFuncRParams(CACTParser::FuncRParamsContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitPrimaryExp(CACTParser::PrimaryExpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitPrimaryUnary(CACTParser::PrimaryUnaryContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUnaryOp(CACTParser::UnaryOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitFuncCall(CACTParser::FuncCallContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitMulOp(CACTParser::MulOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitUnaryToMul(CACTParser::UnaryToMulContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitMulToAdd(CACTParser::MulToAddContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitAddOp(CACTParser::AddOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitAddToRel(CACTParser::AddToRelContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitRelOp(CACTParser::RelOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEqOp(CACTParser::EqOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitRelToEq(CACTParser::RelToEqContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitLAndOp(CACTParser::LAndOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitEqToLAnd(CACTParser::EqToLAndContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitLOrOp(CACTParser::LOrOpContext *ctx) override {
    return visitChildren(ctx);
  }

  virtual std::any visitLAndToLOr(CACTParser::LAndToLOrContext *ctx) override {
    return visitChildren(ctx);
  }


};

