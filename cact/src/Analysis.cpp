// Analysis.cpp
#include "Analysis.h"
#include <iostream>

Analysis::Analysis() : 
    irGen(std::make_unique<IRGenerator>()),
    globalTable(new SymbolTable()),
    current(globalTable),
    Bool({"bool", false, {}, false}),
    inLoop(0),
    return_exist(0)
{
    initBuiltinFunctions();
}

Analysis::~Analysis() {
    delete globalTable;
}

void Analysis::initBuiltinFunctions() {
    auto addBuiltin = [&](const std::string& name, FunType retType, 
                        const std::vector<std::string>& params, 
                        const std::vector<SymType>& paramTypes) {
        globalTable->insertfun(name, retType, params, paramTypes);
        
        // 生成IR函数声明
        FunEntry entry{name, retType, params, paramTypes, 0};
        irGen->generateFunctionDef(entry);
    };
    
    addBuiltin("print_int", FunType::VOID, {"n"}, {{"int", false, {}, false}});
    addBuiltin("print_float", FunType::VOID, {"f"}, {{"float", false, {}, false}});
    addBuiltin("print_char", FunType::VOID, {"c"}, {{"char", false, {}, false}});
    addBuiltin("get_int", FunType::INT, {}, {});
    addBuiltin("get_float", FunType::FLOAT, {}, {});
    addBuiltin("get_char", FunType::CHAR, {}, {});
}

bool Analysis::checkMultiDimInit(const SymType& arrayType, 
                                CACTParser::ConstInitValContext* ctx, 
                                size_t dimIndex) {
    // 检查维度索引是否有效
    if (dimIndex >= arrayType.array_dims.size()) {
        std::cerr << "Error at line " << ctx->getStart()->getLine()
                  << ": array initialization exceeds maximum dimensions ("
                  << arrayType.array_dims.size() << ")\n";
        return false;
    }

    int expectedSize = arrayType.array_dims[dimIndex];
    auto initVals = ctx->constInitVal();

    // 检查初始化数量是否匹配当前维度
    if (initVals.size() > expectedSize && expectedSize > 0) {
        std::cerr << "Error at line " << ctx->getStart()->getLine()
                  << ": too many initializers for array dimension " << dimIndex
                  << " (expected " << expectedSize
                  << ", got " << initVals.size() << ")\n";
        return false;
    }

    // 递归检查每个初始化项
    for (size_t i = 0; i < initVals.size(); ++i) {
        auto initVal = initVals[i];
        if (initVal->constExp()) {
            // 基本类型初始化
            try {
                auto ConstExpResult = std::any_cast<std::pair<SymType, llvm::Value*>>(
                    visitConstExp(initVal->constExp()));
                SymType expType = ConstExpResult.first;
                
                if (arrayType.base_type != expType.base_type || expType.is_array) {
                    std::cerr << "Error at line " << initVal->getStart()->getLine()
                              << ": type mismatch in array initialization at index " << i
                              << " of dimension " << dimIndex << "\n";
                    return false;
                }
            } catch (const std::bad_any_cast&) {
                std::cerr << "Error at line " << initVal->getStart()->getLine()
                          << ": invalid constant expression in array initialization at index "
                          << i << " of dimension " << dimIndex << "\n";
                return false;
            }
        } else {
            // 嵌套初始化
            if (!checkMultiDimInit(arrayType, initVal, dimIndex + 1)) {
                // 嵌套错误信息已经在递归调用中输出
                return false;
            }
        }
    }

    return true;
}

std::any Analysis::visitCompUnit(CACTParser::CompUnitContext *ctx) {
    auto result = visitChildren(ctx);
    std::cout << "analysis done" << std::endl;
    llvm::Module* module = irGen->getModule();
    module->print(llvm::outs(), nullptr);

    std::string outputFilename = "output.txt";

    irGen->dumpIRToFile(outputFilename);
    std::cout << "LLVM IR written to: output.txt" << std::endl;

    return result;
}

// 声明相关规则
std::any Analysis::visitDecl(CACTParser::DeclContext *ctx) {
    //std::cout << "visit Decl" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitConstDecl(CACTParser::ConstDeclContext *ctx) {
    //std::cout << "visit ConstDecl" << std::endl;
    SymType conType;
    conType.base_type = ctx->bType()->getText();
    conType.is_const = true;
    std::vector<int> array_dims;
    
    // 获取当前函数（如果在函数体内）
    llvm::Function* currentFunction = irGen->getBuilder().GetInsertBlock() ? 
                                     irGen->getBuilder().GetInsertBlock()->getParent() : nullptr;

    // 遍历所有ConstDef
    for (auto constDefCtx : ctx->constDef()) {
        std::string Ident = constDefCtx->Ident()->getText();
        array_dims.clear();
        
        // 处理数组维度
        for (auto intconstctx : constDefCtx->IntConst()) {
            int dim = std::stoi(intconstctx->getText());
            array_dims.push_back(dim);
        }

        conType.is_array = !array_dims.empty();
        conType.array_dims = array_dims;

        // 检查初始化合法性
        auto constInitValCtx = constDefCtx->constInitVal();
        llvm::Value* initValue = nullptr;
        
        auto& builder = irGen->getBuilder();
        if (!conType.is_array) {
            // 标量类型初始化
            if (constInitValCtx->constExp()->isEmpty()) {
                std::cerr << "Error at line " << ctx->getStart()->getLine() 
                          << ": Non-arrays cannot be initialized as an array" << std::endl;
                exit(1);
            }
            
            auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitConstExp(constInitValCtx->constExp()));
            SymType exptype = expResult.first;
            
            if (!isSameType(conType, exptype)) {
                std::cerr << "Error at line " << ctx->getStart()->getLine() 
                          << ": Type mismatch during initialization assignment. Expected " 
                          << conType.base_type << ", got " << exptype.base_type << std::endl;
                exit(1);
            }
            
            initValue = expResult.second;
            // 存入符号表
            current->insertsym(Ident, conType);

            llvm::Constant* init = llvm::cast<llvm::Constant>(initValue);
            llvm::Type* llvmType = irGen->getLLVMType(conType);
            if (current->scopeLevel==0)
            {
                llvm::Value* alloca = 
                new llvm::GlobalVariable(
                    *irGen->getModule(),
                    llvmType,
                    conType.is_const,  // 是否为常量
                    llvm::GlobalValue::ExternalLinkage,
                    init,
                    Ident
                );

                // 在符号表中保存LLVM值
                if (auto symEntry = current->lookupsym(Ident)) {
                    const_cast<SymEntry*>(symEntry)->type.value = alloca;
                }
            }
            else{
                llvm::Value* alloca = builder.CreateAlloca(llvmType, nullptr, Ident);
                // 在符号表中保存LLVM值
                if (auto symEntry = current->lookupsym(Ident)) {
                    const_cast<SymEntry*>(symEntry)->type.value = alloca;
                }
                // 如果有初始化值，生成store指令
                if (initValue && current->scopeLevel!=0) {
                    irGen->getBuilder().CreateStore(initValue, alloca);
                }
            }
            
        } else {
            // 数组类型初始化
            auto initList = constInitValCtx->constInitVal();
            
            // 检查是否为扁平化初始化（所有初始化项都是基本类型）
            bool isFlatInit = true;
            for (auto initVal : initList) {
                if (!initVal->constExp()) {
                    isFlatInit = false;
                    break;
                }
            }

            if (isFlatInit) {
                // 扁平化初始化 - 检查元素数量
                size_t capacity = 1;
                for (int dim : array_dims) capacity *= dim;
                
                if (initList.size() > capacity) {
                    std::cerr << "Error at line " << ctx->getStart()->getLine() 
                                << ": Too many initializers for array of size " 
                                << capacity << std::endl;
                    exit(1);
                }
                
                // 检查类型并收集初始化值
                std::vector<llvm::Constant*> initValues;
                for (auto initVal : initList) {
                    auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(
                        visitConstExp(initVal->constExp()));
                    SymType expType = expResult.first;
                    
                    if (conType.base_type != expType.base_type || expType.is_array) {
                        std::cerr << "Error at line " << ctx->getStart()->getLine() 
                                    << ": Type mismatch in array initialization. Expected " 
                                    << conType.base_type << ", got " << expType.base_type << std::endl;
                        exit(1);
                    }
                    initValues.push_back(llvm::cast<llvm::Constant>(expResult.second));
                }
                
                llvm::Constant* zero = llvm::Constant::getNullValue(irGen->getLLVMType(conType.base_type));
                while (initValues.size() < capacity) {
                    initValues.push_back(zero);
                }

                llvm::Type* elemType = irGen->getLLVMType(conType.base_type);
                
                // 创建数组类型
                llvm::Type* arrayLLVMType = irGen->getLLVMType(conType);

                // 存入符号表
                current->insertsym(Ident, conType);

                // 处理全局变量和局部变量的不同情况
                if (current->scopeLevel==0) {
                    llvm::Constant* init = createNestedArrayInitializer(elemType, conType.array_dims, initValues);
                    
                    // 生成IR变量声明
                    llvm::Value* alloca = 
                    new llvm::GlobalVariable(
                        /*Module=*/ *irGen->getModule(),
                        /*Type=*/ arrayLLVMType,
                        /*isConstant=*/ true,  // 常量数组
                        /*Linkage=*/ llvm::GlobalValue::ExternalLinkage,
                        /*Initializer=*/ init,  
                        /*Name=*/ Ident);

                    // 在符号表中保存LLVM值
                    if (auto symEntry = current->lookupsym(Ident)) {
                        const_cast<SymEntry*>(symEntry)->type.value = alloca;
                    }
                } 
                else {
                    // 局部变量初始化
                    llvm::Value* arrayAlloc = builder.CreateAlloca(arrayLLVMType, nullptr, Ident);
                    
                    // 存储初始化值
                    for (size_t i = 0; i < initValues.size(); ++i) {
                        // 计算多维索引
                        std::vector<llvm::Value*> indices;
                        size_t remaining = i;
                        indices.push_back(builder.getInt32(0)); // 第一个维度索引
                        
                        for (size_t dimIdx = 0; dimIdx < conType.array_dims.size(); dimIdx++) {
                            int dimSize = conType.array_dims[dimIdx];
                            int index = remaining % dimSize;
                            indices.push_back(builder.getInt32(index));
                            remaining /= dimSize;
                        }
                        
                        llvm::Value* elemPtr = builder.CreateInBoundsGEP(
                            arrayAlloc->getType()->getPointerElementType(),
                            arrayAlloc,
                            indices,
                            "array.elem");
                            
                        builder.CreateStore(initValues[i], elemPtr);
                    }
                }
            } else {
                // 多维初始化
                if (!checkMultiDimInit(conType, constInitValCtx, 0)) {
                    std::cerr << "Error at line " << ctx->getStart()->getLine() 
                                << ": Invalid multi-dimensional array initialization" << std::endl;
                    exit(1);
                }
            
                // 创建数组类型
                llvm::Type* arrayLLVMType = irGen->getLLVMType(conType);

                // 存入符号表
                current->insertsym(Ident, conType);

                if (current->scopeLevel==0) {
                    std::vector<llvm::Constant*> initValues;
                    generateNestedArrayInit(conType, constDefCtx->constInitVal(), initValues, 0);
                    for (auto* val : initValues) {
                        //val->print(llvm::errs());  // 打印LLVM值
                        //llvm::errs() << "\n";
                    }
                    // 创建常量数组
                    llvm::ArrayType* arrType = llvm::cast<llvm::ArrayType>(arrayLLVMType);

                    //arrType->print(llvm::errs());
                    //llvm::errs() << "\n";
                    llvm::Constant* init = llvm::ConstantArray::get(arrType, initValues);
                    //init->print(llvm::errs());
                    //llvm::errs() << "\n";
                    // 生成IR变量声明
                    llvm::Value* alloca = 
                    new llvm::GlobalVariable(
                        /*Module=*/ *irGen->getModule(),
                        /*Type=*/ arrayLLVMType,
                        /*isConstant=*/ true,  // 常量数组
                        /*Linkage=*/ llvm::GlobalValue::ExternalLinkage,
                        /*Initializer=*/ init,  
                        /*Name=*/ Ident);

                    // 在符号表中保存LLVM值
                    if (auto symEntry = current->lookupsym(Ident)) {
                        const_cast<SymEntry*>(symEntry)->type.value = alloca;
                    }
                }
                else{
                    // 局部变量初始化
                    llvm::Value* arrayAlloc = builder.CreateAlloca(arrayLLVMType, nullptr, Ident);
                    // 处理初始化值
                    std::vector<llvm::Value*> indices;
                    fillMultiDimInit(conType, constDefCtx->constInitVal(), arrayAlloc, 0, indices);
                    if (auto symEntry = current->lookupsym(Ident)) {
                        const_cast<SymEntry*>(symEntry)->type.value = arrayAlloc;
                    }
                }
            }
        }
        //std::cout << "ConstDef Ident: " << Ident << ", Type: " \
                  << (conType.is_array ? "array of " : "") << conType.base_type << std::endl;
    }
    return nullptr;
}

// 生成嵌套初始化结构
void Analysis::generateNestedArrayInit(
    const SymType& arrayType,
    CACTParser::ConstInitValContext* ctx,
    std::vector<llvm::Constant*>& initValues,
    size_t dimIndex
) {
    // 当前维度的期望大小
    size_t currentDimSize = arrayType.array_dims[dimIndex];
    
    // 如果是最后一维，处理基本类型初始化
    if (dimIndex == arrayType.array_dims.size() - 1) {
        std::vector<llvm::Constant*> currentDimValues;
        
        // 处理显式提供的初始值
        for (auto initVal : ctx->constInitVal()) {
            if (initVal->constExp()) {
                auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(
                    visitConstExp(initVal->constExp()));
                currentDimValues.push_back(
                    llvm::cast<llvm::Constant>(expResult.second));
            }
        }
        
        // 填充默认值（0）
        while (currentDimValues.size() < currentDimSize) {
            currentDimValues.push_back(
                llvm::Constant::getNullValue(irGen->getLLVMType(arrayType.base_type)));
        }
        
        // 创建当前维度的常量数组
        llvm::ArrayType* dimType = llvm::ArrayType::get(
            irGen->getLLVMType(arrayType.base_type), 
            currentDimSize);
        initValues.push_back(llvm::ConstantArray::get(dimType, currentDimValues));
        return;
    }
    
    // 处理嵌套维度
    std::vector<llvm::Constant*> nestedInitValues;
    
    // 处理显式提供的初始值
    for (auto initVal : ctx->constInitVal()) {
        std::vector<llvm::Constant*> childInitValues;
        generateNestedArrayInit(arrayType, initVal, childInitValues, dimIndex + 1);
        
        // 合并子维度的初始化值
        nestedInitValues.insert(nestedInitValues.end(), 
                              childInitValues.begin(), 
                              childInitValues.end());
    }
    
    // 填充默认值（全零数组）
    while (nestedInitValues.size() < currentDimSize) {
        llvm::ArrayType* childType = llvm::ArrayType::get(
            irGen->getLLVMType(arrayType.base_type),
            arrayType.array_dims[dimIndex + 1]);
        nestedInitValues.push_back(
            llvm::ConstantAggregateZero::get(childType));
    }
    if (dimIndex!=0)
    {
        // 创建当前维度的常量数组
        llvm::ArrayType* dimType = llvm::ArrayType::get(
            nestedInitValues[0]->getType(),
            currentDimSize);
        initValues.push_back(llvm::ConstantArray::get(dimType, nestedInitValues));
    }
    else{
        initValues = nestedInitValues;
    }
}

llvm::Constant* Analysis::createNestedArrayInitializer(llvm::Type* elemType, 
                                           const std::vector<int>& dims,
                                           const std::vector<llvm::Constant*>& flatValues,
                                           size_t startIndex,
                                           size_t currentDim) {
    if (currentDim == dims.size() - 1) {
        // 最内层维度 - 创建一维数组
        std::vector<llvm::Constant*> elements;
        for (int i = 0; i < dims[currentDim]; i++) {
            elements.push_back(flatValues[startIndex + i]);
        }
        return llvm::ConstantArray::get(llvm::ArrayType::get(elemType, dims[currentDim]), elements);
    }
    
    // 外层维度 - 递归创建嵌套数组
    std::vector<llvm::Constant*> subArrays;
    int subArraySize = 1;
    for (size_t i = currentDim + 1; i < dims.size(); i++) {
        subArraySize *= dims[i];
    }
    
    for (int i = 0; i < dims[currentDim]; i++) {
        subArrays.push_back(createNestedArrayInitializer(
            elemType, dims, flatValues, startIndex + i * subArraySize, currentDim + 1));
    }
    
    return llvm::ConstantArray::get(
        llvm::ArrayType::get(subArrays[0]->getType(), dims[currentDim]), subArrays);
}

void Analysis::fillMultiDimInit(const SymType& arrayType,
                              CACTParser::ConstInitValContext* ctx,
                              llvm::Value* arrayPtr,
                              size_t dimIndex,
                              std::vector<llvm::Value*>& indices) {
    auto& builder = irGen->getBuilder();

    if (dimIndex >= arrayType.array_dims.size()) {
        // 到达最内层，处理基本类型初始化
        auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitConstExp(ctx->constExp()));
        llvm::Value* initValue = expResult.second;
        
        // 计算元素指针
        std::vector<llvm::Value*> gepIndices = {builder.getInt32(0)};
        gepIndices.insert(gepIndices.end(), indices.begin(), indices.end());
        llvm::Value* elemPtr = builder.CreateInBoundsGEP(
            arrayPtr->getType()->getPointerElementType(),
            arrayPtr, 
            gepIndices,
            "array.elem");
        
        // 存储初始化值
        builder.CreateStore(initValue, elemPtr);
        return;
    }

    // 处理当前维度
    size_t currentDim = arrayType.array_dims[dimIndex];
    auto initVals = ctx->constInitVal();
    
    // 递归处理每个初始化项
    for (size_t i = 0; i < initVals.size(); ++i) {
        indices.push_back(builder.getInt32(i));
        
        if (initVals[i]->constExp()) {
            // 基本类型初始化（处理部分初始化情况）
            auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitConstExp(initVals[i]->constExp()));
            llvm::Value* initValue = expResult.second;
            
            std::vector<llvm::Value*> gepIndices = {builder.getInt32(0)};
            gepIndices.insert(gepIndices.end(), indices.begin(), indices.end());

            llvm::Value* elemPtr = builder.CreateInBoundsGEP(
                arrayPtr->getType()->getPointerElementType(),
                arrayPtr, 
                gepIndices,
                "array.elem");
                
            builder.CreateStore(initValue, elemPtr);
        } else {
            // 嵌套初始化
            fillMultiDimInit(arrayType, initVals[i], arrayPtr, dimIndex + 1, indices);
        }
        
        indices.pop_back();
    }

    // 填充默认值（0）
    for (size_t i = initVals.size(); i < currentDim; ++i) {
        indices.push_back(builder.getInt32(i));
        
        std::vector<llvm::Value*> gepIndices(indices.begin(), indices.end());
        llvm::Value* elemPtr = builder.CreateInBoundsGEP(
            arrayPtr, 
            gepIndices,
            "array.elem");
            
        llvm::Value* zero = irGen->getZeroValue(arrayType.base_type);
        builder.CreateStore(zero, elemPtr);
        
        indices.pop_back();
    }
}

std::any Analysis::visitBType(CACTParser::BTypeContext *ctx) {
    //std::cout << "visit BType : " << ctx->getText() << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitConstDef(CACTParser::ConstDefContext *ctx) {
    //std::cout << "visit ConstDef" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitConstInitVal(CACTParser::ConstInitValContext *ctx) {
    //std::cout << "visit ConstInitVal" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitVarDecl(CACTParser::VarDeclContext *ctx) {
    //std::cout << "visit VarDecl" << std::endl;
    //std::cout << "Matched text: '" << ctx->getText() << std::endl;
    SymType varType;
    varType.base_type = ctx->bType()->getText();
    varType.is_const = false;
    std::vector<int> array_dims;

    // 获取当前函数（如果在函数体内）
    llvm::Function* currentFunction = irGen->getBuilder().GetInsertBlock() ? 
                                    irGen->getBuilder().GetInsertBlock()->getParent() : nullptr;

    // 遍历所有varDef
    for (auto varDefCtx : ctx->varDef()) {
        //std::cout << "Matched text: '" << varDefCtx->getText() << std::endl;
        std::string Ident = varDefCtx->Ident()->getText();
        array_dims.clear();
        
        // 处理数组维度
        for (auto intconstctx : varDefCtx->IntConst()) {
            int dim = std::stoi(intconstctx->getText());
            array_dims.push_back(dim);
        }

        varType.is_array = !array_dims.empty();
        varType.array_dims = array_dims;

        // 检查初始化合法性
        auto constInitValCtx = varDefCtx->constInitVal();
        llvm::Value* initValue = nullptr;
        
        if (constInitValCtx == nullptr || constInitValCtx->isEmpty()) {
            // 存入符号表
            
            current->insertsym(Ident, varType);
            
            // 如果是全局变量且未初始化，需要显式初始化为0
            if (current->scopeLevel == 0) {
                llvm::Type* arrayLLVMType = irGen->getLLVMType(varType);
                
                // 创建全0初始化器
                llvm::Constant* zeroInit = llvm::Constant::getNullValue(arrayLLVMType);
                
                // 创建全局变量
                llvm::Value* globalVar = 
                    new llvm::GlobalVariable(
                        *irGen->getModule(),
                        arrayLLVMType,
                        false, // isConstant
                        llvm::GlobalValue::ExternalLinkage,
                        zeroInit,
                        Ident);
                        
                // 更新符号表中的值
                if (auto symEntry = current->lookupsym(Ident)) {
                    const_cast<SymEntry*>(symEntry)->type.value = globalVar;
                }
            }else {
                // 生成IR变量声明
                llvm::Value* alloca = irGen->generateVarDecl(Ident, varType, currentFunction);
                
                // 在符号表中保存LLVM值
                if (auto symEntry = current->lookupsym(Ident)) {
                    const_cast<SymEntry*>(symEntry)->type.value = alloca;
                }
                // 局部变量：显式存储0值
                auto& builder = irGen->getBuilder();
                
                if (!varType.is_array) {
                    // 标量类型：直接存储0
                    llvm::Value* zero = irGen->getZeroValue(varType.base_type);
                    builder.CreateStore(zero, alloca);
                } else {
                    // 数组类型：逐个元素初始化为0
                    llvm::Type* elemType = irGen->getLLVMType(varType.base_type);
                    size_t totalElements = 1;
                    for (int dim : varType.array_dims) {
                        totalElements *= dim;
                    }
                    
                    // 对每个数组元素生成store指令
                    for (size_t i = 0; i < totalElements; ++i) {
                        std::vector<llvm::Value*> indices = {
                            builder.getInt32(0),  // 第一个维度索引
                            builder.getInt32(i)   // 元素索引
                        };
                        
                        llvm::Value* elemPtr = builder.CreateInBoundsGEP(
                            alloca->getType()->getPointerElementType(),
                            alloca,
                            indices,
                            "array.elem");
                            
                        llvm::Value* zero = irGen->getZeroValue(varType.base_type);
                        builder.CreateStore(zero, elemPtr);
                    }
                }
            }
        }
        else{
            if (!varType.is_array) {
                // 标量类型初始化
                if (constInitValCtx->constExp()->isEmpty()) {
                    std::cerr << "Error at line " << ctx->getStart()->getLine() 
                            << ": Non-arrays cannot be initialized as an array" << std::endl;
                    exit(1);
                }
                
                auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitConstExp(constInitValCtx->constExp()));
                SymType exptype = expResult.first;
                
                if (!isSameType(varType, exptype)) {
                    std::cerr << "Error at line " << ctx->getStart()->getLine() 
                            << ": Type mismatch during initialization assignment. Expected " 
                            << varType.base_type << ", got " << exptype.base_type << std::endl;
                    exit(1);
                }
                
                initValue = expResult.second;
                // 存入符号表
                current->insertsym(Ident, varType);
                
                llvm::Constant* init = llvm::cast<llvm::Constant>(initValue);
                llvm::Type* llvmType = irGen->getLLVMType(varType);
                if (current->scopeLevel==0)
                {
                    llvm::Value* alloca = 
                    new llvm::GlobalVariable(
                        *irGen->getModule(),
                        llvmType,
                        varType.is_const,  // 是否为常量
                        llvm::GlobalValue::ExternalLinkage,
                        init,
                        Ident
                    );

                    // 在符号表中保存LLVM值
                    if (auto symEntry = current->lookupsym(Ident)) {
                        const_cast<SymEntry*>(symEntry)->type.value = alloca;
                    }
                }
                else{
                    llvm::Value* alloca = irGen->getBuilder().CreateAlloca(llvmType, nullptr, Ident);
                    // 在符号表中保存LLVM值
                    if (auto symEntry = current->lookupsym(Ident)) {
                        const_cast<SymEntry*>(symEntry)->type.value = alloca;
                    }
                    // 如果有初始化值，生成store指令
                    if (initValue && current->scopeLevel!=0) {
                        irGen->getBuilder().CreateStore(initValue, alloca);
                    }
                }
            } else {
                // 数组类型初始化
                auto initList = constInitValCtx->constInitVal();
                //std::cout << "1" << std::endl;
                // 检查是否为扁平化初始化（所有初始化项都是基本类型）
                bool isFlatInit = true;
                for (auto initVal : initList) {
                    if (!initVal->constExp()) {
                        isFlatInit = false;
                        break;
                    }
                }
                //std::cout << "2" << std::endl;
                auto& builder = irGen->getBuilder();
                if (isFlatInit) {
                    // 扁平化初始化 - 检查元素数量
                    size_t capacity = 1;
                    for (int dim : array_dims) capacity *= dim;
                    
                    if (initList.size() > capacity) {
                        std::cerr << "Error at line " << ctx->getStart()->getLine() 
                                    << ": Too many initializers for array of size " 
                                    << capacity << std::endl;
                        exit(1);
                    }
                    //std::cout << "3" << std::endl;
                    // 检查类型并收集初始化值
                    std::vector<llvm::Constant*> initValues;
                    for (auto initVal : initList) {
                        auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(
                            visitConstExp(initVal->constExp()));
                        SymType expType = expResult.first;
                        
                        if (varType.base_type != expType.base_type || expType.is_array) {
                            std::cerr << "Error at line " << ctx->getStart()->getLine() 
                                        << ": Type mismatch in array initialization. Expected " 
                                        << varType.base_type << ", got " << expType.base_type << std::endl;
                            exit(1);
                        }
                        initValues.push_back(llvm::cast<llvm::Constant>(expResult.second));
                    }
                    //std::cout << "4" << std::endl;
                    llvm::Constant* zero = llvm::Constant::getNullValue(irGen->getLLVMType(varType.base_type));
                    while (initValues.size() < capacity) {
                        initValues.push_back(zero);
                    }
                    //std::cout << "5" << std::endl;
                    llvm::Type* elemType = irGen->getLLVMType(varType.base_type);
                    
                    // 创建数组类型
                    llvm::Type* arrayLLVMType = irGen->getLLVMType(varType);

                    // 存入符号表
                    current->insertsym(Ident, varType);
                    //std::cout << "6" << std::endl;
                    // 处理全局变量和局部变量的不同情况
                    if (current->scopeLevel==0) {
                        llvm::Constant* init = createNestedArrayInitializer(elemType, varType.array_dims, initValues);
                        
                        // 生成IR变量声明
                        llvm::Value* alloca = 
                        new llvm::GlobalVariable(
                            /*Module=*/ *irGen->getModule(),
                            /*Type=*/ arrayLLVMType,
                            /*isConstant=*/ false,  // 变量数组
                            /*Linkage=*/ llvm::GlobalValue::ExternalLinkage,
                            /*Initializer=*/ init,  
                            /*Name=*/ Ident);

                        // 在符号表中保存LLVM值
                        if (auto symEntry = current->lookupsym(Ident)) {
                            const_cast<SymEntry*>(symEntry)->type.value = alloca;
                        }
                    } 
                    else {
                        // 局部变量初始化
                        llvm::Value* arrayAlloc = builder.CreateAlloca(arrayLLVMType, nullptr, Ident);
                        
                        // 存储初始化值
                        for (size_t i = 0; i < initValues.size(); ++i) {
                            // 计算多维索引
                            std::vector<llvm::Value*> indices;
                            size_t remaining = i;
                            indices.push_back(builder.getInt32(0)); // 第一个维度索引
                            
                            for (size_t dimIdx = 0; dimIdx < varType.array_dims.size(); dimIdx++) {
                                int dimSize = varType.array_dims[dimIdx];
                                int index = remaining % dimSize;
                                indices.push_back(builder.getInt32(index));
                                remaining /= dimSize;
                            }
                            
                            llvm::Value* elemPtr = builder.CreateInBoundsGEP(
                                arrayAlloc->getType()->getPointerElementType(),
                                arrayAlloc,
                                indices,
                                "array.elem");
                                
                            builder.CreateStore(initValues[i], elemPtr);
                        }

                        // 在符号表中保存LLVM值
                        if (auto symEntry = current->lookupsym(Ident)) {
                            const_cast<SymEntry*>(symEntry)->type.value = arrayAlloc;
                        }
                    }
                } else {
                    //std::cout << "7" << std::endl;
                    // 多维初始化
                    if (!checkMultiDimInit(varType, constInitValCtx, 0)) {
                        std::cerr << "Error at line " << ctx->getStart()->getLine() 
                                    << ": Invalid multi-dimensional array initialization" << std::endl;
                        exit(1);
                    }
                
                    // 创建数组类型
                    llvm::Type* arrayLLVMType = irGen->getLLVMType(varType);

                    // 存入符号表
                    current->insertsym(Ident, varType);
                    //std::cout << "8" << std::endl;
                    if (current->scopeLevel==0) {
                        std::vector<llvm::Constant*> initValues;
                        generateNestedArrayInit(varType, varDefCtx->constInitVal(), initValues, 0);
                        for (auto* val : initValues) {
                            //val->print(llvm::errs());  // 打印LLVM值
                            //llvm::errs() << "\n";
                        }
                        // 创建常量数组
                        llvm::ArrayType* arrType = llvm::cast<llvm::ArrayType>(arrayLLVMType);

                        //arrType->print(llvm::errs());
                        //llvm::errs() << "\n";
                        llvm::Constant* init = llvm::ConstantArray::get(arrType, initValues);
                        //init->print(llvm::errs());
                        //llvm::errs() << "\n";
                        // 生成IR变量声明
                        llvm::Value* alloca = 
                        new llvm::GlobalVariable(
                            /*Module=*/ *irGen->getModule(),
                            /*Type=*/ arrayLLVMType,
                            /*isConstant=*/ false,  // 常量数组
                            /*Linkage=*/ llvm::GlobalValue::ExternalLinkage,
                            /*Initializer=*/ init,  
                            /*Name=*/ Ident);

                        // 在符号表中保存LLVM值
                        if (auto symEntry = current->lookupsym(Ident)) {
                            const_cast<SymEntry*>(symEntry)->type.value = alloca;
                        }
                    }
                    else{
                        // 局部变量初始化
                        llvm::Value* arrayAlloc = builder.CreateAlloca(arrayLLVMType, nullptr, Ident);
                        // 处理初始化值
                        std::vector<llvm::Value*> indices;
                        fillMultiDimInit(varType, varDefCtx->constInitVal(), arrayAlloc, 0, indices);
                        if (auto symEntry = current->lookupsym(Ident)) {
                            const_cast<SymEntry*>(symEntry)->type.value = arrayAlloc;
                        }
                    }
                }
            }
        }
        
        //std::cout << "9" << std::endl;
        //std::cout << "varDef Ident: " << Ident << ", Type: " \
                  << (varType.is_array ? "array of " : "") << varType.base_type << std::endl;
        /*std::cout << "DEBUG: After processing VarDef for '" << Ident << "'" << std::endl;
        const SymEntry* entry = current->lookupsym(Ident);
        //std::cout << "1" << std::endl;
        if (entry) {
            //std::cout << "2" << std::endl;
            if (entry->type.value) {
                //std::cout << "3" << std::endl;
                std::cout << "  - SymbolTable value is VALID. LLVM Value is: ";
                //std::cout << "4" << std::endl;
                entry->type.value->print(llvm::outs());
                //std::cout << "5" << std::endl;
                std::cout << std::endl;
            } else {
                std::cout << "  - SymbolTable value is NULLPTR!" << std::endl;
            }
        } else {
            std::cout << "  - Symbol not found in table (this should not happen)" << std::endl;
        }*/
    }
    return nullptr;
}

std::any Analysis::visitVarDef(CACTParser::VarDefContext *ctx) {
    //std::cout << "visit VarDef" << std::endl;
    return visitChildren(ctx);
}

// 函数相关规则
std::any Analysis::visitFuncDef(CACTParser::FuncDefContext *ctx) {
    //std::cout << "visit FuncDef" << std::endl;
    
    // 1. 解析函数返回类型
    FunType retType = stringToFunType(ctx->funcType()->getText());
    std::string funcName = ctx->Ident()->getText();
    
    // 2. 解析函数参数
    std::vector<std::string> paramNames;
    std::vector<SymType> paramTypes;
    std::vector<llvm::Type*> llvmParamTypes;
    
    if (auto paramsCtx = ctx->funcFParams()) {
        for (auto paramCtx : paramsCtx->funcFParam()) {
            // 解析参数类型
            SymType paramType;
            paramType.base_type = paramCtx->bType()->getText();
            paramType.is_const = false;
            
            // 处理数组维度
            std::vector<int> array_dims;
            if (paramCtx->getText().find("[]") != std::string::npos) {
                array_dims.push_back(-1); // -1表示可变长度数组
            }
            
            for (auto intconstctx : paramCtx->IntConst()) {
                array_dims.push_back(std::stoi(intconstctx->getText()));
            }
            
            paramType.is_array = !array_dims.empty();
            paramType.array_dims = array_dims;
            
            // 保存参数信息
            std::string paramName = paramCtx->Ident()->getText();
            paramNames.push_back(paramName);
            paramTypes.push_back(paramType);
            
            // 生成对应的LLVM类型
            llvmParamTypes.push_back(irGen->getLLVMType(paramType));
            
            //std::cout << "params Ident: " << paramName \
                      << ", Type: " << paramType.is_array \
                      << paramType.base_type << std::endl;
        }
    }
    
    // 3. 存入符号表
    current->insertfun(funcName, retType, paramNames, paramTypes);
    
    // 4. 生成IR函数声明
    FunEntry entry{funcName, retType, paramNames, paramTypes, 0};
    llvm::Function* function = irGen->generateFunctionDef(entry);
    
    // 5. 创建函数入口基本块
    llvm::BasicBlock* entryBB = irGen->createBasicBlock(function, "entry");
    irGen->blockStack.push(entryBB);
    irGen->getBuilder().SetInsertPoint(entryBB);
    
    // 6. 为参数存储到符号表
    if (function->arg_size() > 0) {
        auto argIt = function->arg_begin();
        for (size_t i = 0; i < paramNames.size(); ++i, ++argIt) {
            
            /*// 在符号表中保存LLVM值
            if (auto symEntry = current->lookupsym(paramNames[i])) {
                const_cast<SymEntry*>(symEntry)->type.value = alloca;
            }*/
        }
    }
    
    // 7. 设置当前函数名和返回类型
    current_funname.push(funcName);
    current_rettype.push(retType);
    
    // 8. 访问函数体
    visitBlock(ctx->block());
    
    /*// 9. 处理没有返回语句的情况
    if (retType != FunType::VOID && !irGen->getBuilder().GetInsertBlock()->getTerminator()) {
        if (retType == FunType::INT) {
            irGen->getBuilder().CreateRet(llvm::ConstantInt::get(irGen->getBuilder().getInt32Ty(), 0));
        } else if (retType == FunType::FLOAT) {
            irGen->getBuilder().CreateRet(llvm::ConstantFP::get(irGen->getBuilder().getFloatTy(), 0.0));
        } else {
            irGen->getBuilder().CreateRetVoid();
        }
    }*/

    // 10. 验证函数IR
    if (llvm::verifyFunction(*function, &llvm::errs())) {
        std::cerr << "Error: Invalid function generated for " << funcName << std::endl;
    }
    
    // 11. 清理函数状态
    current_funname.pop();
    current_rettype.pop();
    irGen->blockStack.pop();
    
    //std::cout << "FunDef Ident: " << funcName << ", Type: " << ctx->funcType()->getText() << std::endl;
    return nullptr;
}

std::any Analysis::visitFuncType(CACTParser::FuncTypeContext *ctx) {
    //std::cout << "visit FuncType : " << ctx->getText() << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitFuncFParams(CACTParser::FuncFParamsContext *ctx) {
    //std::cout << "visit FuncFParams" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitFuncFParam(CACTParser::FuncFParamContext *ctx) {
    //std::cout << "visit FuncFParam" << std::endl;
    return visitChildren(ctx);
}

// 语句块与语句规则
std::any Analysis::visitBlock(CACTParser::BlockContext *ctx) {
    // 1. 进入新作用域
    current = current->enterScope();

    auto* func_def = dynamic_cast<CACTParser::FuncDefContext*>(ctx->parent);
    //auto* stmtctx = dynamic_cast<CACTParser::StmtContext*>(ctx->parent);

    // 2. 处理函数参数（如果是函数体块）
    llvm::Function* currentFunction = irGen->getFunction(current_funname.top());
    if (func_def != nullptr) {
        std::string funcName = func_def->Ident()->getText();
        current_funname.push(funcName);
        current_rettype.push(stringToFunType(func_def->funcType()->getText()));
        
        // 获取当前LLVM函数
        currentFunction = irGen->getFunction(funcName);
        
        // 处理函数参数
        if (func_def->funcFParams()) {
            auto argIter = currentFunction->arg_begin();
            
            for (auto param : func_def->funcFParams()->funcFParam()) {
                // 解析参数类型
                SymType type;
                type.base_type = param->bType()->getText();
                type.is_const = false;
                
                std::vector<int> array_dims;
                if (param->getText().find("[]") != -1) {
                    array_dims.push_back(-1);
                }

                for (auto intconstctx : param->IntConst()) {
                    array_dims.push_back(std::stoi(intconstctx->getText()));
                }
                
                type.is_array = !array_dims.empty();
                type.array_dims = array_dims;

                // 存入符号表
                std::string paramName = param->Ident()->getText();
                current->insertsym(paramName, type);
                
                // 生成参数alloca和store指令
                if (argIter != currentFunction->arg_end()) {
                    llvm::Value* alloca = irGen->generateVarDecl(paramName, type, currentFunction);
                    irGen->getBuilder().CreateStore(&*argIter, alloca);
                    
                    // 在符号表中保存LLVM值
                    if (auto symEntry = current->lookupsym(paramName)) {
                        const_cast<SymEntry*>(symEntry)->type.value = alloca;
                    }
                    
                    ++argIter;
                }
            }
        }
    }
    // 4. 访问块内语句
    auto result = visitChildren(ctx);
    
    // 5. 处理返回语句检查
    if (func_def != nullptr) {
        if (current_rettype.top() != FunType::VOID && return_exist == 0) {
            
            std::cerr << "Error: Function " << current_funname.top() 
                     << " lacks a return statement" << std::endl;
            exit(1);
        }
        return_exist = 0;
        current_funname.pop();
        current_rettype.pop();
    }
    
    // 6. 离开作用域
    current->print();
    SymbolTable* temp = current;
    current = current->parent;
    delete temp;
    
    return result;
}

std::any Analysis::visitBlockItem(CACTParser::BlockItemContext *ctx) {
    //std::cout << "visit BlockItem" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitStmt(CACTParser::StmtContext *ctx) {
    //std::cout << "visit Stmt" << std::endl;
    auto& builder = irGen->getBuilder();
    llvm::Function* currentFunc = builder.GetInsertBlock()->getParent();

    std::string word = ctx->children[0]->getText();
    
    if (ctx->lVal()) {
        // 赋值语句: lVal '=' exp ';'
        auto lvalResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitLVal(ctx->lVal()));
        auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitExp(ctx->exp()));
        
        SymType lvalType = lvalResult.first;
        SymType expType = expResult.first;
        
        if (!isSameType(lvalType, expType)) {
            std::cerr << "Type mismatch in assignment" << std::endl;
            exit(1);
        }
        
        // 检查左值是否为常量
        if (lvalType.is_const) {
            std::cerr << "Error: Cannot assign to const lvalue" << std::endl;
            exit(1);
        }

        // 生成IR代码
        llvm::Value* lvalAddr = lvalResult.second;
        llvm::Value* expValue = expResult.second;
        //std::cout << lvalAddr << std::endl;
        //std::cout << expValue << std::endl;
        //expValue->print(llvm::outs());
        llvm::BasicBlock* currentBB = builder.GetInsertBlock();
        if (currentBB) {
        //std::cout << "Current BB: " << currentBB->getName().str() << std::endl;
        }
        builder.CreateStore(expValue, lvalAddr);
    }
    else if (ctx->block()) {
        // 块语句: block
        visitBlock(ctx->block());
    }
    else if (ctx->stmt(0) && word == "if") {
        // if语句: 'if' '(' cond ')' stmt ('else' stmt)?
        //std::cout << "If condition" << std::endl;
        auto condResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitCond(ctx->cond()));
        SymType condType = condResult.first;
        //std::cout << "?" << std::endl;
        if (!isSameType(condType, Bool)) {
            std::cerr << "If condition must be boolean" << std::endl;
            exit(1);
        }
        
        // 生成IR代码
        llvm::Value* condValue = condResult.second;
        llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(
            irGen->getContext(), "if.then", currentFunc);
        llvm::BasicBlock* elseBB = ctx->stmt(1) ? 
            llvm::BasicBlock::Create(irGen->getContext(), "if.else", currentFunc) : nullptr;
        llvm::BasicBlock* mergeBB = llvm::BasicBlock::Create(
            irGen->getContext(), "if.merge", currentFunc);
        if (elseBB) {
            builder.CreateCondBr(condValue, thenBB, elseBB);
        } else {
            builder.CreateCondBr(condValue, thenBB, mergeBB);
        }
        //std::cout << "??" << std::endl;
        // 生成then块
        builder.SetInsertPoint(thenBB);
        //llvm::Value* one = llvm::ConstantInt::get(builder.getInt32Ty(), 1);
        //builder.CreateStore(one, condValue);
        llvm::BasicBlock* currentBB = builder.GetInsertBlock();
        //if (currentBB) {
            //std::cout << "Current BB: " << currentBB->getName().str() << std::endl;
        //}else{
        //    
        //}
        visitStmt(ctx->stmt(0));
        builder.CreateBr(mergeBB);
        //std::cout << "???" << std::endl;
        // 生成else块（如果有）
        if (elseBB) {
            builder.SetInsertPoint(elseBB);
            visitStmt(ctx->stmt(1));
            builder.CreateBr(mergeBB);
        }
        builder.SetInsertPoint(mergeBB);
    } 
    else if (ctx->stmt(0)) {
        // while语句: 'while' '(' cond ')' stmt
        //std::cout << "while condition" << std::endl;
        //std::cout << ctx->getText() << std::endl;
        // 生成IR代码
        llvm::BasicBlock* condBB = llvm::BasicBlock::Create(
            irGen->getContext(), "while.cond", currentFunc);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(
            irGen->getContext(), "while.body");
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(
            irGen->getContext(), "while.end");
        
        // 保存当前循环信息
        irGen->pushLoop(condBB, endBB);
        
        // 生成条件块
        builder.CreateBr(condBB);
        builder.SetInsertPoint(condBB);

        auto condResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitCond(ctx->cond()));
        SymType condType = condResult.first;
        if (!isSameType(condType, Bool)) {
            std::cerr << "While condition must be boolean" << std::endl;
            exit(1);
        }
        llvm::Value* condValue = condResult.second;
        builder.CreateCondBr(condValue, bodyBB, endBB);
        
        // 生成循环体
        currentFunc->getBasicBlockList().push_back(bodyBB);
        builder.SetInsertPoint(bodyBB);
        inLoop++;
        visitStmt(ctx->stmt(0));
        inLoop--;
        builder.CreateBr(condBB);
        
        // 生成结束块
        currentFunc->getBasicBlockList().push_back(endBB);
        builder.SetInsertPoint(endBB);
        
        // 恢复循环信息
        irGen->popLoop();
    }
    else if (word == "return") {
        //std::cout << "visit return" << std::endl;
        // 返回语句: 'return' exp? ';'
        if (ctx->exp()) {
            //std::cout << "1" << std::endl;
            auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitExp(ctx->exp()));
            //std::cout << "2" << std::endl;
            SymType retType = expResult.first;
            
            if (retType.is_array) {
                std::cerr << "wrong return type"<< std::endl;
                exit(1);
            }
            //std::cout << "3" << std::endl;
            FunType retfuntype = stringToFunType(retType.base_type);
            if (retfuntype != current_rettype.top()) {
                std::cerr << "wrong return type" << std::endl;
                exit(1);
            }

            // 生成IR代码
            llvm::Value* retValue = expResult.second;
            builder.CreateRet(retValue);
            //std::cout << "4" << std::endl;
        } else {
            if (FunType::VOID != current_rettype.top()) {
                std::cerr << "Empty return in non-void function" << std::endl;
                exit(1);
            }
            // 生成IR代码
            builder.CreateRetVoid();
        }
        return_exist = 1;
        //std::cout << "visit return done" << std::endl;
    }
    else if (word == "break") {
        // break语句: 'break' ';'
        if (inLoop <= 0) {
            std::cerr << "Break statement outside loop" << std::endl;
            exit(1);
        }
        
        // 生成IR代码
        auto loopInfo = irGen->getCurrentLoop();
        builder.CreateBr(loopInfo.endBB);
    } 
    else if (word == "continue") {
        // continue语句: 'continue' ';'
        if (inLoop <= 0) {
            std::cerr << "Continue statement outside loop" << std::endl;
            exit(1);
        }
        
        // 生成IR代码
        auto loopInfo = irGen->getCurrentLoop();
        builder.CreateBr(loopInfo.condBB);
    }
    else if (ctx->exp()) {
        // 表达式语句: exp ';'
        visitExp(ctx->exp()); // 只需计算表达式，不关心返回值
    }
    return nullptr;
}

std::any Analysis::visitExp(CACTParser::ExpContext *ctx) {
    //std::cout << "visit Exp" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitConstExp(CACTParser::ConstExpContext *ctx) {
    //std::cout << "visit ConstExp" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitCond(CACTParser::CondContext *ctx) {
    // 1. 正常访问 lOrExp，获取其结果
    auto lorResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitLOrExp(ctx->lOrExp()));

    // 2. 调用辅助函数将其转换为布尔类型
    auto boolResultPair = convertToBool(lorResult.first, lorResult.second);

    // 3. 直接返回转换后的结果
    return boolResultPair;
}

std::any Analysis::visitLVal(CACTParser::LValContext *ctx) {
    //std::cout << "visit LVal" << std::endl;
    auto& builder = irGen->getBuilder();
    //std::cout << "1" << std::endl;
    // 1. 查找符号
    std::string identName = ctx->Ident()->getText();
    const SymEntry* symbol = current->lookupsym(identName);
    SymType type;
    
    if (symbol == nullptr) {
        std::cerr << "Error: Symbol '" << identName << "' is undefined" << std::endl;
        exit(1);
    }
    type = symbol->type;
    
    // 获取LLVM值（可能是alloca指令或全局变量）
    llvm::Value* baseAddr = symbol->type.value;
    if (!baseAddr) {
        std::cerr << "Error: No LLVM value for symbol '" << identName << "'" << std::endl;
        exit(1);
    }
    //std::cout << "2" << std::endl;
    // 2. 处理数组访问（如果有索引）
    auto indices = ctx->exp(); // 所有索引表达式
    llvm::Value* finalAddr = baseAddr;
    llvm::Type* finalType = irGen->getLLVMType(type);

    if (!indices.empty()) {
        // 2.1 检查基础类型是否为数组
        if (!type.is_array) {
            std::cerr << "Error: '" << identName << "' is not an array" << std::endl;
            exit(1);
        }
        //std::cout << "2.2" << std::endl;
        // 2.2 检查索引数量是否超过维度
        if (indices.size() > type.array_dims.size()) {
            std::cerr << "Error: Array '" << identName << "' has " 
                     << type.array_dims.size() << " dimension(s), but "
                     << indices.size() << " index(es) provided" << std::endl;
            exit(1);
        }
        //std::cout << "2.3" << std::endl;
        // 2.3 生成GEP指令计算元素地址
        std::vector<llvm::Value*> gepIndices;
        gepIndices.push_back(llvm::ConstantInt::get(builder.getInt32Ty(), 0)); // 第一个索引固定为0
        //std::cout << "1" << std::endl;
        for (auto indexExpr : indices) {
            // 检查索引类型
            auto expResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitExp(indexExpr));
            SymType indexType = expResult.first;
            if (indexType.base_type != "int" || indexType.is_array) {
                std::cerr << "Error: Array index must be non-array integer" << std::endl;
                exit(1);
            }
            
            // 获取索引值
            llvm::Value* indexVal = expResult.second;
            
            // 将索引转换为i32类型
            if (indexVal->getType() != builder.getInt32Ty()) {
                indexVal = builder.CreateIntCast(indexVal, builder.getInt32Ty(), true);
            }
            
            gepIndices.push_back(indexVal);
        }
        //std::cout << "2" << std::endl;
        /*std::cout << "DEBUG: GEP for " << identName << " at line " << ctx->getStart()->getLine() << std::endl;
        std::cout << "  - Base address (baseAddr): ";
        baseAddr->print(llvm::outs());
        std::cout << std::endl;
        std::cout << "  - Base address type: ";
        baseAddr->getType()->print(llvm::outs());
        std::cout << std::endl;
        std::cout << "  - Pointer element type for GEP: ";
        baseAddr->getType()->getPointerElementType()->print(llvm::outs());
        std::cout << std::endl;
        std::cout << "  - GEP indices: ";
        for (auto* idx : gepIndices) {
            idx->print(llvm::outs());
            std::cout << ", ";
        }
        std::cout << std::endl;*/
        // 生成GEP指令
        finalAddr = builder.CreateInBoundsGEP(
            baseAddr->getType()->getPointerElementType(),
            baseAddr,
            gepIndices,
            "arrayidx"
        );
        //std::cout << "2.4" << std::endl;
        // 2.4 更新返回类型（减少维度）
        if (indices.size() == type.array_dims.size()) {
            // 完全索引（如 arr[1][2] → 返回元素类型）
            type.is_array = false;
            type.array_dims.clear();
            finalType = irGen->getLLVMType(type);
        } else {
            // 部分索引（如 arr[1][2][3] 访问 arr[1] → 返回 int[2][3]）
            type.array_dims.erase(
                type.array_dims.begin(),
                type.array_dims.begin() + indices.size()
            );
            finalType = irGen->getLLVMType(type);
        }
    }
    //std::cout << "3" << std::endl;
    // 3. 根据上下文决定返回地址还是加载值
    // 如果是赋值语句的左值，返回地址；如果是表达式中的使用，加载值
    bool isLoad = true; // 默认需要加载
    
    // 检查父节点是否是赋值语句的左值
    if (auto parent = ctx->parent) {
        if (dynamic_cast<CACTParser::StmtContext*>(parent)) {
            auto stmtCtx = dynamic_cast<CACTParser::StmtContext*>(parent);
            if (stmtCtx->lVal() == ctx) {
                isLoad = false; // 赋值语句的左值，返回地址
            }
        }
    }

    if (isLoad) {
        // 生成load指令
        llvm::Value* loadedValue = builder.CreateLoad(finalType, finalAddr, identName + ".val");
        return std::make_pair(type, loadedValue);
    } else {
        // 返回地址
        return std::make_pair(type, finalAddr);
    }
}

std::any Analysis::visitNumber(CACTParser::NumberContext *ctx) {
    //std::cout << "visit Number" << std::endl;

    SymType type;
    type.is_const = true; // 字面量都是常量
    type.is_array = false;
    
    llvm::Value* value = nullptr;
    auto& builder = irGen->getBuilder();
    
    if (ctx->IntConst()) {
        type.base_type = "int";
        //std::cout<<"int"<<std::endl;
        int intValue = std::stoi(ctx->IntConst()->getText(),nullptr,0);
        value = llvm::ConstantInt::get(builder.getInt32Ty(), intValue);
        //std::cout<< intValue <<std::endl;
    } 
    else if (ctx->FloatConst()) {
        type.base_type = "float";
        //std::cout<<"float"<<std::endl;
        float floatValue = std::stof(ctx->FloatConst()->getText());
        value = llvm::ConstantFP::get(builder.getFloatTy(), floatValue);
    }
    else if (ctx->CharConst()) {
        type.base_type = "char";
        //std::cout<<"char"<<std::endl;
        char charValue = ctx->CharConst()->getText()[1]; // 跳过单引号
        value = llvm::ConstantInt::get(builder.getInt8Ty(), charValue);
    }
    
    // 返回类型信息和LLVM值
    return std::make_pair(type, value);
}

std::any Analysis::visitFuncRParams(CACTParser::FuncRParamsContext *ctx) {
    //std::cout << "visit FuncRParams" << std::endl;
    return visitChildren(ctx);
}

std::any Analysis::visitPrimaryExp(CACTParser::PrimaryExpContext *ctx) {
    //std::cout << "visit PrimaryExp" << std::endl;
    
    if (ctx->exp() != nullptr) {
        // 处理括号表达式 (exp)
        return visitExp(ctx->exp());
    }
    else if (ctx->lVal() != nullptr) {
        // 处理左值 lVal
        auto lvalResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitLVal(ctx->lVal()));
        SymType type = lvalResult.first;
        llvm::Value* value = lvalResult.second;
        
        // 如果返回的是地址，需要加载值
        if (value->getType()->isPointerTy()) {
            value = irGen->getBuilder().CreateLoad(
                value->getType()->getPointerElementType(),
                value,
                "loadval"
            );
        }
        
        return std::make_pair(type, value);
    }
    else {
        // 处理数字常量 number
        return visitNumber(ctx->number());
    }
}

std::any Analysis::visitUnaryExp(CACTParser::UnaryExpContext *ctx) {
    //std::cout << "visit UnaryExp" << std::endl;
    auto& builder = irGen->getBuilder();
    
    if (ctx->primaryExp() != nullptr) {
        // 处理基本表达式
        return visitPrimaryExp(ctx->primaryExp());
    }
    else if (ctx->unaryExp() != nullptr) {
        // 处理一元运算符
        auto unaryResult = std::any_cast<std::pair<SymType, llvm::Value*>>(visitUnaryExp(ctx->unaryExp()));
        SymType type = unaryResult.first;
        llvm::Value* value = unaryResult.second;

        std::string op = ctx->children[0]->getText();
        
        if (op == "!") {
            // 1. 将操作数转换为布尔值
            auto boolPair = convertToBool(unaryResult.first, unaryResult.second);
            llvm::Value* boolValue = boolPair.second;
            
            // 2. 对转换后的布尔值执行 xor with true (等价于 not)
            //    或者直接用 CreateICmpEQ with false
            llvm::Value* notResult = builder.CreateICmpEQ(boolValue, builder.getFalse(), "logicalnot");

            return std::make_pair(Bool, notResult);
        }
        else if (op == "-") {
            // 负号运算
            if (type.base_type == "int") {
                return std::make_pair(type, builder.CreateNeg(value, "neg"));
            }
            else if (type.base_type == "float") {
                return std::make_pair(type, builder.CreateFNeg(value, "fneg"));
            }
            else {
                std::cerr << "Error: Unary '-' operator requires numeric operand" << std::endl;
                exit(1);
            }
        }
        else if (op == "+") {
            // 正号运算 - 直接返回原值
            return unaryResult;
        }
    }
    else {
        // 处理函数调用
        std::string funcName = ctx->Ident()->getText();
        const FunEntry* funcEntry = current->lookupfun(funcName);
        
        if (funcEntry == nullptr) {
            std::cerr << "Error: Function '" << funcName << "' is undefined" << std::endl;
            exit(1);
        }
        
        // 准备参数
        std::vector<llvm::Value*> args;
        if (ctx->funcRParams()) {
            auto params = ctx->funcRParams()->exp();
            if (params.size() != funcEntry->params_name.size()) {
                std::cerr << "Error: Function '" << funcName << "' expects " 
                         << funcEntry->params_name.size() << " arguments, but "
                         << params.size() << " provided" << std::endl;
                exit(1);
            }
            
            for (size_t i = 0; i < params.size(); ++i) {
                auto paramInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitExp(params[i]));
                if (!isSameType(paramInfo.first, funcEntry->params_type[i])) {
                    std::cerr << "Error: Type mismatch for argument " << i+1 
                             << " in call to function '" << funcName << "'" << std::endl;
                    exit(1);
                }
                args.push_back(paramInfo.second);
            }
        }
        
        // 生成函数调用
        llvm::Function* callee = irGen->getModule()->getFunction(funcName);
        if (!callee) {
            std::cerr << "Error: Function '" << funcName << "' not found in IR" << std::endl;
            exit(1);
        }
        // 构造返回类型
        SymType retType;
        retType.base_type = FunTypeTostring(funcEntry->type);
        retType.is_array = false;
        retType.is_const = false;
        if (funcEntry->type!=FunType::VOID)
        {
            llvm::Value* retVal = builder.CreateCall(callee, args, "calltmp");
            return std::make_pair(retType, retVal);
        }
        else{
            llvm::Value* retVal = builder.CreateCall(callee, args);
            return std::make_pair(retType, retVal);
        }
    }
    
    return nullptr;
}

std::any Analysis::visitMulExp(CACTParser::MulExpContext *ctx) {
    //std::cout << "visit MulExp" << std::endl;
    auto& builder = irGen->getBuilder();
    
    if (ctx->mulExp() == nullptr) {
        // 基本情况：直接返回一元表达式
        return visitUnaryExp(ctx->unaryExp());
    }
    else {
        // 递归处理乘法表达式
        auto leftInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitMulExp(ctx->mulExp()));
        auto rightInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitUnaryExp(ctx->unaryExp()));
        
        SymType leftType = leftInfo.first;
        SymType rightType = rightInfo.first;
        llvm::Value* leftVal = leftInfo.second;
        llvm::Value* rightVal = rightInfo.second;
        
        // 类型检查
        if (!isSameType(leftType, rightType)) {
            std::cerr << "Error: Type mismatch in multiplication expressionat line " << ctx->getStart()->getLine() << std::endl;
            exit(1);
        }
        
        // 根据操作符生成IR
        llvm::Value* result = nullptr;
        std::string op = ctx->children[1]->getText();
        
        if (leftType.base_type == "int") {
            if (op == "*") {
                result = builder.CreateMul(leftVal, rightVal, "mul_tmp");
            }
            else if (op == "/") {
                result = builder.CreateSDiv(leftVal, rightVal, "div_tmp");
            }
            else if (op == "%") {
                result = builder.CreateSRem(leftVal, rightVal, "mod_tmp");
            }
        }
        else if (leftType.base_type == "float") {
            if (op == "*") {
                result = builder.CreateFMul(leftVal, rightVal, "fmul_tmp");
            }
            else if (op == "/") {
                result = builder.CreateFDiv(leftVal, rightVal, "fdiv_tmp");
            }
            else {
                std::cerr << "Error: Modulo operation not supported for float type" << std::endl;
                exit(1);
            }
        }
        else {
            std::cerr << "Error: Multiplication operation not supported for type " << leftType.base_type << std::endl;
            exit(1);
        }
        
        return std::make_pair(leftType, result);
    }
}

std::any Analysis::visitAddExp(CACTParser::AddExpContext *ctx) {
    //std::cout << "visit AddExp" << std::endl;
    auto& builder = irGen->getBuilder();
    
    if (ctx->addExp() == nullptr) {
        // 基本情况：直接返回乘法表达式
        return visitMulExp(ctx->mulExp());
    }
    else {
        // 递归处理加法表达式
        auto leftInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitAddExp(ctx->addExp()));
        auto rightInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitMulExp(ctx->mulExp()));
        
        SymType leftType = leftInfo.first;
        SymType rightType = rightInfo.first;
        llvm::Value* leftVal = leftInfo.second;
        llvm::Value* rightVal = rightInfo.second;
        
        // 类型检查
        if (!isSameType(leftType, rightType)) {
            std::cerr << "Error: Type mismatch in addition expression at line " << ctx->getStart()->getLine()  << std::endl;
            exit(1);
        }
        
        // 根据操作符生成IR
        llvm::Value* result = nullptr;
        std::string op = ctx->children[1]->getText();
        
        if (leftType.base_type == "int") {
            if (op == "+") {
                result = builder.CreateAdd(leftVal, rightVal, "add_tmp");
            }
            else if (op == "-") {
                result = builder.CreateSub(leftVal, rightVal, "sub_tmp");
            }
        }
        else if (leftType.base_type == "float") {
            if (op == "+") {
                result = builder.CreateFAdd(leftVal, rightVal, "fadd_tmp");
            }
            else if (op == "-") {
                result = builder.CreateFSub(leftVal, rightVal, "fsub_tmp");
            }
        }
        else {
            std::cerr << "Error: Addition operation not supported for type " << leftType.base_type << std::endl;
            exit(1);
        }
        
        return std::make_pair(leftType, result);
    }
}

std::any Analysis::visitRelExp(CACTParser::RelExpContext *ctx) {
    //std::cout << "visit RelExp" << std::endl;
    auto& builder = irGen->getBuilder();
    
    if (ctx->relExp() == nullptr) {
        // 基本情况：直接返回加法表达式
        return visitAddExp(ctx->addExp());
    }
    else {
        // 递归处理关系表达式
        auto leftInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitRelExp(ctx->relExp()));
        auto rightInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitAddExp(ctx->addExp()));
        
        SymType leftType = leftInfo.first;
        SymType rightType = rightInfo.first;
        llvm::Value* leftVal = leftInfo.second;
        llvm::Value* rightVal = rightInfo.second;

        // 规则1: 如果一边是bool，另一边是int/char，将bool提升为int
        if (isSameType(leftType, Bool) && (rightType.base_type == "int" || rightType.base_type == "char")) {
            leftVal = builder.CreateZExt(leftVal, builder.getInt32Ty(), "booltoint");
            leftType.base_type = "int"; // 更新类型信息以便后续判断
        }
        if ((leftType.base_type == "int" || leftType.base_type == "char") && isSameType(rightType, Bool)) {
            rightVal = builder.CreateZExt(rightVal, builder.getInt32Ty(), "booltoint");
            rightType.base_type = "int"; // 更新类型信息
        }
        
        // 类型检查
        if (!isSameType(leftType, rightType)) {
            std::cerr << "Error: Type mismatch in relational expression" << std::endl;
            exit(1);
        }
        
        // 获取关系运算符
        std::string op = ctx->children[1]->getText();
        
        // 生成IR指令
        llvm::Value* cmpResult = nullptr;
        if (leftType.base_type == "int") {
            if (op == "<") {
                cmpResult = builder.CreateICmpSLT(leftVal, rightVal, "cmptmp");
            }
            else if (op == ">") {
                cmpResult = builder.CreateICmpSGT(leftVal, rightVal, "cmptmp");
            }
            else if (op == "<=") {
                cmpResult = builder.CreateICmpSLE(leftVal, rightVal, "cmptmp");
            }
            else if (op == ">=") {
                cmpResult = builder.CreateICmpSGE(leftVal, rightVal, "cmptmp");
            }
        }
        else if (leftType.base_type == "float") {
            if (op == "<") {
                cmpResult = builder.CreateFCmpOLT(leftVal, rightVal, "cmptmp");
            }
            else if (op == ">") {
                cmpResult = builder.CreateFCmpOGT(leftVal, rightVal, "cmptmp");
            }
            else if (op == "<=") {
                cmpResult = builder.CreateFCmpOLE(leftVal, rightVal, "cmptmp");
            }
            else if (op == ">=") {
                cmpResult = builder.CreateFCmpOGE(leftVal, rightVal, "cmptmp");
            }
        }
        else {
            std::cerr << "Error: Relational operation not supported for type " 
                     << leftType.base_type << std::endl;
            exit(1);
        }
        
        // 关系表达式的结果总是bool类型
        return std::make_pair(Bool, cmpResult);
    }
}

std::any Analysis::visitEqExp(CACTParser::EqExpContext *ctx) {
    //std::cout << "visit EqExp" << std::endl;
    auto& builder = irGen->getBuilder();
    
    if (ctx->eqExp() == nullptr) {
        // 基本情况：直接返回关系表达式
        return visitRelExp(ctx->relExp());
    }
    else {
        // 递归处理等式表达式
        auto leftInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitEqExp(ctx->eqExp()));
        auto rightInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitRelExp(ctx->relExp()));
        
        SymType leftType = leftInfo.first;
        SymType rightType = rightInfo.first;
        llvm::Value* leftVal = leftInfo.second;
        llvm::Value* rightVal = rightInfo.second;

        // 规则1: 如果一边是bool，另一边是int/char，将bool提升为int
        if (isSameType(leftType, Bool) && (rightType.base_type == "int" || rightType.base_type == "char")) {
            leftVal = builder.CreateZExt(leftVal, builder.getInt32Ty(), "booltoint");
            leftType.base_type = "int"; // 更新类型信息以便后续判断
        }
        if ((leftType.base_type == "int" || leftType.base_type == "char") && isSameType(rightType, Bool)) {
            rightVal = builder.CreateZExt(rightVal, builder.getInt32Ty(), "booltoint");
            rightType.base_type = "int"; // 更新类型信息
        }
        
        // 类型检查
        if (!isSameType(leftType, rightType)) {
            std::cerr << "Error: Type mismatch in equality expression" << std::endl;
            exit(1);
        }
        
        // 获取等式运算符
        std::string op = ctx->children[1]->getText();
        
        // 生成IR指令
        llvm::Value* cmpResult = nullptr;
        if (leftType.base_type == "int" || leftType.base_type == "bool") {
            if (op == "==") {
                cmpResult = builder.CreateICmpEQ(leftVal, rightVal, "eqtmp");
            }
            else if (op == "!=") {
                cmpResult = builder.CreateICmpNE(leftVal, rightVal, "netmp");
            }
        }
        else if (leftType.base_type == "float") {
            if (op == "==") {
                cmpResult = builder.CreateFCmpOEQ(leftVal, rightVal, "feqtmp");
            }
            else if (op == "!=") {
                cmpResult = builder.CreateFCmpONE(leftVal, rightVal, "fnetmp");
            }
        }
        else {
            std::cerr << "Error: Equality operation not supported for type " 
                     << leftType.base_type << std::endl;
            exit(1);
        }
        
        // 等式表达式的结果总是bool类型
        return std::make_pair(Bool, cmpResult);
    }
}

std::any Analysis::visitLAndExp(CACTParser::LAndExpContext *ctx) {
    auto& builder = irGen->getBuilder();
    
    if (ctx->lAndExp() == nullptr) {
        return visitEqExp(ctx->eqExp());
    } else {
        auto leftInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitLAndExp(ctx->lAndExp()));
        
        // --- 关键修改 ---
        // 将左操作数转换为布尔值
        auto leftBoolPair = convertToBool(leftInfo.first, leftInfo.second);
        llvm::Value* leftVal = leftBoolPair.second;
        
        llvm::Function* func = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* lhsBB = builder.GetInsertBlock();
        llvm::BasicBlock* rhsBB = llvm::BasicBlock::Create(builder.getContext(), "and.rhs", func);
        llvm::BasicBlock* mergeBB = llvm::BasicBlock::Create(builder.getContext(), "and.end", func);
        
        builder.CreateCondBr(leftVal, rhsBB, mergeBB);
        
        builder.SetInsertPoint(rhsBB);
        auto rightInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitEqExp(ctx->eqExp()));
        // 将右操作数也转换为布尔值
        auto rightBoolPair = convertToBool(rightInfo.first, rightInfo.second);
        llvm::Value* rhsResult = rightBoolPair.second;
        llvm::BasicBlock* rhsEndBB = builder.GetInsertBlock();
        builder.CreateBr(mergeBB);
        
        builder.SetInsertPoint(mergeBB);
        llvm::PHINode* phi = builder.CreatePHI(builder.getInt1Ty(), 2, "and.result");
        phi->addIncoming(builder.getFalse(), lhsBB);
        phi->addIncoming(rhsResult, rhsEndBB);
        
        llvm::Value* phiValue = static_cast<llvm::Value*>(phi);
        return std::make_pair(Bool, phiValue);
    }
}

std::any Analysis::visitLOrExp(CACTParser::LOrExpContext *ctx) {
    auto& builder = irGen->getBuilder();
    
    if (ctx->lOrExp() == nullptr) {
        return visitLAndExp(ctx->lAndExp());
    } else {
        auto leftInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitLOrExp(ctx->lOrExp()));

        // --- 关键修改 ---
        // 将左操作数转换为布尔值
        auto leftBoolPair = convertToBool(leftInfo.first, leftInfo.second);
        llvm::Value* leftVal = leftBoolPair.second;
        
        llvm::Function* func = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* lhsBB = builder.GetInsertBlock();
        llvm::BasicBlock* rhsBB = llvm::BasicBlock::Create(builder.getContext(), "or.rhs", func);
        llvm::BasicBlock* mergeBB = llvm::BasicBlock::Create(builder.getContext(), "or.end", func);
        
        builder.CreateCondBr(leftVal, mergeBB, rhsBB);
        
        builder.SetInsertPoint(rhsBB);
        auto rightInfo = std::any_cast<std::pair<SymType, llvm::Value*>>(visitLAndExp(ctx->lAndExp()));
        // 将右操作数也转换为布尔值
        auto rightBoolPair = convertToBool(rightInfo.first, rightInfo.second);
        llvm::Value* rhsResult = rightBoolPair.second;
        llvm::BasicBlock* rhsEndBB = builder.GetInsertBlock();
        builder.CreateBr(mergeBB);
        
        builder.SetInsertPoint(mergeBB);
        llvm::PHINode* phi = builder.CreatePHI(builder.getInt1Ty(), 2, "or.result");
        phi->addIncoming(builder.getTrue(), lhsBB);
        phi->addIncoming(rhsResult, rhsEndBB);
        
        llvm::Value* phiValue = static_cast<llvm::Value*>(phi);
        return std::make_pair(Bool, phiValue);
    }
}

std::any Analysis::visitErrorNode(tree::ErrorNode* node) {
    std::cerr << "Error: Invalid syntax at line " 
              << node->getSymbol()->getLine() 
              << ":" << node->getSymbol()->getCharPositionInLine()
              << " - " << node->getText() << std::endl;
    
    // 生成错误处理IR
    auto& builder = irGen->getBuilder();
    
    // 1. 生成错误信息字符串
    llvm::Value* errorMsg = builder.CreateGlobalStringPtr(
        "Syntax error encountered during compilation"
    );
    
    // 3. 生成程序终止指令
    builder.CreateUnreachable();
    
    // 验证模块以确保IR一致性
    if (verifyModule(*irGen->getModule(), &llvm::errs())) {
        std::cerr << "Generated invalid IR after syntax error" << std::endl;
    }
    
    exit(1);
    return nullptr;
}

std::pair<SymType, llvm::Value*> Analysis::convertToBool(const SymType& type, llvm::Value* value) {
    if (isSameType(type, Bool)) {
        // 如果已经是布尔类型，直接返回
        return {type, value};
    }

    auto& builder = irGen->getBuilder();
    llvm::Value* boolResult = nullptr;

    if (type.base_type == "int" || type.base_type == "char") {
        // 整型/字符型：与0比较
        boolResult = builder.CreateICmpNE(
            value, 
            irGen->getZeroValue(type.base_type),
            "tobool"
        );
    } 
    else if (type.base_type == "float") {
        // 浮点型：与0.0比较
        boolResult = builder.CreateFCmpONE( // ONE: Ordered, Not Equal
            value,
            irGen->getZeroValue(type.base_type),
            "tobool"
        );
    }
    // 注意：这里没有处理指针类型，如果你的语言支持，也需要添加
    else {
        // 对于不支持的类型，抛出错误
        std::cerr << "Error: Cannot convert type '" << type.base_type << "' to boolean for logical operation." << std::endl;
        exit(1);
    }

    return {Bool, boolResult};
}