#include <iostream>
#include <vector>
#include <unordered_map>
#include <string>
#include <stdexcept>

#include "llvm/IR/Value.h" 

struct SymType {
    std::string base_type;       // 基础类型（如 "int"）
    bool is_array;       // 是否为数组
    std::vector<int> array_dims; // 数组维度
    bool is_const;       // 可选：是否常量
    llvm::Value* value; 
};

enum class FunType { INT, FLOAT, CHAR, VOID };

struct SymEntry {
    std::string name;   // 变量名
    SymType type;   // 符号类型
    int scopeLevel;     // 作用域层级（全局为0，嵌套作用域递增）
    //std::string value;
    // 可扩展其他属性
};

struct FunEntry {
    std::string name;   // 函数名
    FunType type;   // 返回类型
    std::vector<std::string> params_name;
    std::vector<SymType> params_type;    // 参数类型
    int scopeLevel;     // 作用域层级（全局为0，嵌套作用域递增）
    // 可扩展其他属性
};

class SymbolTable {
public:
    std::unordered_map<std::string, SymEntry> symentries; // 当前作用域的符号
    std::unordered_map<std::string, FunEntry> funentries; // 当前作用域的函数
    SymbolTable* parent; // 指向父作用域的符号表
    int scopeLevel;      // 当前作用域层级

    SymbolTable();

    // 进入新作用域（如函数体、代码块）
    SymbolTable* enterScope() ;

    // 插入符号（若存在同名符号则报错）
    void insertsym(const std::string& name, const SymType& type) ;

    // 插入函数（若存在同名符号则报错）
    void insertfun(const std::string& name, const FunType& type,
        const std::vector<std::string>& params_name,
        const std::vector<SymType>& params_type) ;

    // 查找符号（递归查找父作用域）
    const SymEntry* lookupsym(const std::string& name) const;

    // 查找函数
    const FunEntry* lookupfun(const std::string& name) const;

    // 打印当前及所有父作用域的符号表内容
    void print(bool include_parents = true) const {
        std::cout << "===== 作用域层级 " << scopeLevel << " =====" << std::endl;
        
        // 打印变量符号
        for (const auto& [name, entry] : symentries) {
            std::cout << "变量: " << name 
                      << " | 类型: " << formatSymType(entry.type)
                      << " | 作用域: " << entry.scopeLevel << std::endl;
        }

        // 打印函数符号
        for (const auto& [name, entry] : funentries) {
            std::cout << "函数: " << name 
                      << formatFunEntry(entry) 
                      << " | 作用域: " << entry.scopeLevel << std::endl;
        }

        // 递归打印父作用域
        if (include_parents && parent) {
            parent->print(true);
        }
    }

private:
    // 格式化类型信息
    static std::string formatSymType(const SymType& type) {
        std::string str = type.base_type;
        if (type.is_array) {
            str += "[";
            for (size_t i = 0; i < type.array_dims.size(); ++i) {
                if (i > 0) str += "][";
                if (type.array_dims[i] == -1) {
                    str += "?";
                } else {
                    str += std::to_string(type.array_dims[i]);
                }
            }
            str += "]";
        }
        if (type.is_const) str += " (const)";
        return str;
    }

    // 格式化函数信息
    static std::string formatFunEntry(const FunEntry& entry) {
        std::string str = " : " + funTypeToString(entry.type) + "(";
        for (size_t i = 0; i < entry.params_name.size(); ++i) {
            if (i > 0) str += ", ";
            str += formatSymType(entry.params_type[i]) 
                   + " " + entry.params_name[i];
        }
        str += ")";
        return str;
    }

    // FunType 转字符串
    static std::string funTypeToString(FunType type) {
        switch (type) {
            case FunType::INT:   return "int";
            case FunType::FLOAT: return "float";
            case FunType::CHAR:  return "char";
            case FunType::VOID:  return "void";
            default:             return "unknown";
        }
    }

};

FunType stringToFunType(const std::string& typeStr) ;
std::string FunTypeTostring(const FunType& FunType) ;

bool isSameType(const SymType& type1, const SymType& type2) ;