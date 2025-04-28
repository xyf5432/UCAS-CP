#include "symboltable.h"

SymbolTable::SymbolTable() : parent(nullptr), scopeLevel(0) {}

// 进入新作用域（如函数体、代码块）
SymbolTable* SymbolTable::enterScope() {
    SymbolTable* newScope = new SymbolTable();
    newScope->parent = this;
    newScope->scopeLevel = scopeLevel + 1;
    return newScope;
}

// 插入符号（若存在同名符号则报错）
void SymbolTable::insertsym(const std::string& name, const SymType& type) {
    if (symentries.find(name) != symentries.end()) {
        throw std::runtime_error("重复定义变量: " + name);
    }
    symentries[name] = {name, type, scopeLevel};
}

// 插入函数（若存在同名符号则报错）
void SymbolTable::insertfun(const std::string& name, const FunType& type,
                const std::vector<std::string>& params_name,
                const std::vector<SymType>& params_type) {
    if (funentries.find(name) != funentries.end()) {
        throw std::runtime_error("重复定义函数: " + name);
    }
    funentries[name] = {name, type, params_name, params_type, scopeLevel};
}

// 查找符号（递归查找父作用域）
const SymEntry* SymbolTable::lookupsym(const std::string& name) const {
    if (auto it = symentries.find(name); it != symentries.end()) {
        return &it->second;
    }
    return parent ? parent->lookupsym(name) : nullptr;
}

// 查找函数
const FunEntry* SymbolTable::lookupfun(const std::string& name) const {
    const SymbolTable* global = this;
    while (global->parent != nullptr) { // 循环找到最顶层
        global = global->parent;
    }
    if (auto it = global->funentries.find(name); it != global->funentries.end()) {
        return &it->second;
    }
    return nullptr;
}

FunType stringToFunType(const std::string& typeStr) {
    if (typeStr == "int")    return FunType::INT;
    if (typeStr == "float")  return FunType::FLOAT;
    if (typeStr == "char")   return FunType::CHAR;
    if (typeStr == "void")  return FunType::VOID;

    throw std::invalid_argument("Invalid FunType: " + typeStr);
}