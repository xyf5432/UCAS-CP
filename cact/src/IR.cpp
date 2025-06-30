// IR.cpp
#include "IR.h"
#include "llvm/IR/Verifier.h"

IRGenerator::IRGenerator() : 
    contextPtr(std::make_unique<llvm::LLVMContext>()),
    context(*contextPtr),  // 初始化引用
    module(std::make_unique<llvm::Module>("CACT_module", context)),
    builder(context)  // 初始化IRBuilder
{
    // 构造函数体
}

// 1. 类型系统映射
llvm::Type* IRGenerator::getLLVMType(const SymType& type) {
    llvm::Type* baseType = nullptr;
    if (type.base_type == "int") baseType = llvm::Type::getInt32Ty(context);
    else if (type.base_type == "float") baseType = llvm::Type::getFloatTy(context);
    else if (type.base_type == "char") baseType = llvm::Type::getInt8Ty(context);
    else if (type.base_type == "bool") baseType = llvm::Type::getInt1Ty(context);
    else if (type.base_type == "void") baseType = llvm::Type::getVoidTy(context);
    
    if (type.is_array) {
        // 反向遍历维度
        for (auto it = type.array_dims.rbegin(); it != type.array_dims.rend(); ++it) {
            //std::cout << "Array dimensions: [";
            //for (size_t i = 0; i < type.array_dims.size(); ++i) {
            //    std::cout << type.array_dims[i];
            //    if (i != type.array_dims.size() - 1) {
            //        std::cout << ", ";
            //    }
            //}
            //std::cout << "]" << std::endl;
        
            //std::cout << "First element in reverse: " << *type.array_dims.rbegin() << std::endl;
            //std::cout << "Last element in reverse: " << *type.array_dims.rend() << std::endl;
            //std::cout << *it << std::endl;
            if (*it == -1) {
                // 可变长度数组只能作为最外层维度
                if (std::next(it) != type.array_dims.rend()) {
                    throw std::runtime_error("Variable-length dimension must be the outermost");
                }
                baseType = llvm::ArrayType::get(baseType, 0); // 0表示可变长度
            } else {
                baseType = llvm::ArrayType::get(baseType, *it);
            }
        }
    }
    return baseType;
}

llvm::Type* IRGenerator::getLLVMType(std::string type) {
    llvm::Type* baseType = nullptr;
    if (type == "int") baseType = llvm::Type::getInt32Ty(context);
    else if (type == "float") baseType = llvm::Type::getFloatTy(context);
    else if (type == "char") baseType = llvm::Type::getInt8Ty(context);
    else if (type == "bool") baseType = llvm::Type::getInt1Ty(context);
    else if (type == "void") baseType = llvm::Type::getVoidTy(context);
    return baseType;
}

// 2. 变量声明生成
llvm::Value* IRGenerator::generateVarDecl(
    const std::string& name,
    const SymType& type,
    llvm::Function* currentFunction,
    llvm::Constant* initValue
) {
    llvm::Type* llvmType = getLLVMType(type);
    
    if (currentFunction) {
        // 1. 保存当前 builder 的插入点
        llvm::IRBuilder<>::InsertPoint savedIP = builder.saveIP();

        // 2. 将 builder 的插入点临时移动到函数入口块的开头
        builder.SetInsertPoint(&currentFunction->getEntryBlock(), 
                               currentFunction->getEntryBlock().begin());
        
        // 3. 使用持久的 builder 创建 alloca 指令
        llvm::Value* alloca = builder.CreateAlloca(llvmType, nullptr, name);

        // 4. 恢复 builder 到原来的插入点
        builder.restoreIP(savedIP);

        // 5. 返回创建好的 alloca
        return alloca;
    } else {
        return new llvm::GlobalVariable(
            *module,
            llvmType,
            type.is_const,  // 是否为常量
            llvm::GlobalValue::InternalLinkage,
            initValue,
            name
        );
    }
}

// 3. 函数定义生成
llvm::Function* IRGenerator::generateFunctionDef(const FunEntry& entry) {
    std::vector<llvm::Type*> paramTypes;
    for (const auto& paramType : entry.params_type) {
        paramTypes.push_back(getLLVMType(paramType));
    }
    
    llvm::Type* retType = getLLVMType({FunTypeTostring(entry.type), false, {}, false});
    llvm::FunctionType* funcType = llvm::FunctionType::get(retType, paramTypes, false);
    
    llvm::Function* function = llvm::Function::Create(
        funcType, llvm::Function::ExternalLinkage, entry.name, module.get());
    
    // 设置参数名
    unsigned idx = 0;
    for (auto& arg : function->args()) {
        arg.setName(entry.params_name[idx++]);
    }
    
    return function;
}

// 4. 表达式生成
llvm::Value* IRGenerator::generateBinaryExpr(char op, llvm::Value* L, llvm::Value* R, const SymType& type) {
    if (type.base_type == "float") {
        switch(op) {
            case '+': return builder.CreateFAdd(L, R, "faddtmp");
            case '-': return builder.CreateFSub(L, R, "fsubtmp");
            case '*': return builder.CreateFMul(L, R, "fmultmp");
            case '/': return builder.CreateFDiv(L, R, "fdivtmp");
            case '<': return builder.CreateFCmpULT(L, R, "fcmptmp");
            // 其他浮点运算...
        }
    } else {
        switch(op) {
            case '+': return builder.CreateAdd(L, R, "addtmp");
            case '-': return builder.CreateSub(L, R, "subtmp");
            case '*': return builder.CreateMul(L, R, "multmp");
            case '/': return builder.CreateSDiv(L, R, "divtmp");
            case '<': return builder.CreateICmpSLT(L, R, "icmptmp");
            // 其他整型运算...
        }
    }
    throw std::runtime_error("未知操作符");
}

// 5. 数组访问生成
llvm::Value* IRGenerator::generateArrayAccess(llvm::Value* arrayPtr, 
                                            const std::vector<llvm::Value*>& indices,
                                            const SymType& arrayType) {
    // 构建GEP索引
    std::vector<llvm::Value*> gepIndices = {
        llvm::ConstantInt::get(context, llvm::APInt(32, 0))
    };
    gepIndices.insert(gepIndices.end(), indices.begin(), indices.end());
    
    // 生成GEP指令
    llvm::Value* elemPtr = builder.CreateInBoundsGEP(
        getLLVMType(arrayType), arrayPtr, gepIndices, "array_ptr");
    
    return builder.CreateLoad(getLLVMType(arrayType), elemPtr, "array_val");
}

// 6. 控制流生成
void IRGenerator::generateIfStmt(llvm::Value* cond, 
                               const std::function<void()>& thenGen,
                               const std::function<void()>& elseGen) {
    llvm::Function* function = builder.GetInsertBlock()->getParent();
    
    llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "if.then", function);
    llvm::BasicBlock* elseBB = elseGen ? 
        llvm::BasicBlock::Create(context, "if.else", function) : nullptr;
    llvm::BasicBlock* mergeBB = llvm::BasicBlock::Create(context, "if.end", function);
    
    builder.CreateCondBr(cond, thenBB, elseBB ? elseBB : mergeBB);
    
    // 生成then块
    builder.SetInsertPoint(thenBB);
    thenGen();
    builder.CreateBr(mergeBB);
    
    // 生成else块（如果有）
    if (elseGen && elseBB) {
        builder.SetInsertPoint(elseBB);
        elseGen();
        builder.CreateBr(mergeBB);
    }
    
    // 继续在merge块生成
    builder.SetInsertPoint(mergeBB);
}

void IRGenerator::generateWhileLoop(const std::function<llvm::Value*()>& condGen,
                                  const std::function<void()>& bodyGen) {
    llvm::Function* function = builder.GetInsertBlock()->getParent();
    
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "while.cond", function);
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "while.body", function);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "while.end", function);
    
    // 保存循环结束块用于break
    loopEndBBStack.push(endBB);
    
    builder.CreateBr(condBB);
    
    // 条件判断
    builder.SetInsertPoint(condBB);
    llvm::Value* cond = condGen();
    builder.CreateCondBr(cond, bodyBB, endBB);
    
    // 循环体
    builder.SetInsertPoint(bodyBB);
    bodyGen();
    builder.CreateBr(condBB);
    
    // 结束块
    builder.SetInsertPoint(endBB);
    loopEndBBStack.pop();
}

// 7. 工具方法
void IRGenerator::finalizeFunction(llvm::Function* function, llvm::Value* returnValue) {
    if (function->getReturnType()->isVoidTy()) {
        builder.CreateRetVoid();
    } else if (returnValue) {
        builder.CreateRet(returnValue);
    } else {
        // 处理默认返回值
        if (function->getReturnType()->isIntegerTy()) {
            builder.CreateRet(llvm::ConstantInt::get(function->getReturnType(), 0));
        } else if (function->getReturnType()->isFloatingPointTy()) {
            builder.CreateRet(llvm::ConstantFP::get(function->getReturnType(), 0.0));
        } else {
            builder.CreateRet(llvm::UndefValue::get(function->getReturnType()));
        }
    }
    
    // 验证函数
    llvm::verifyFunction(*function);
}

llvm::Value* IRGenerator::getZeroValue(const std::string& typeName) {
    auto& context = getContext();
    if (typeName == "int") {
        return llvm::ConstantInt::get(llvm::Type::getInt32Ty(context), 0);
    } else if (typeName == "float") {
        return llvm::ConstantFP::get(llvm::Type::getFloatTy(context), 0.0);
    } else if (typeName == "char") {
        return llvm::ConstantInt::get(llvm::Type::getInt8Ty(context), 0);
    } else if (typeName == "bool") {
        return llvm::ConstantInt::get(llvm::Type::getInt1Ty(context), 0);
    }
    // 其他类型...
    return nullptr; // 或抛出异常
}

llvm::Value* IRGenerator::generateConstArrayInit(
    const SymType& arrayType,
    const std::vector<llvm::Value*>& initValues
) {
    // 1. 获取数组元素类型
    llvm::Type* elemType = getLLVMType(arrayType);
    
    // 2. 创建常量数组
    std::vector<llvm::Constant*> constInitValues;
    for (auto val : initValues) {
        constInitValues.push_back(llvm::cast<llvm::Constant>(val));
    }
    
    // 3. 填充默认值（0）
    size_t totalElements = 1;
    for (int dim : arrayType.array_dims) {
        totalElements *= dim;
    }
    
    while (constInitValues.size() < totalElements) {
        constInitValues.push_back(llvm::Constant::getNullValue(elemType));
    }
    
    // 4. 生成LLVM常量数组
    llvm::ArrayType* arrayLLVMType = llvm::ArrayType::get(
        elemType, 
        totalElements
    );
    
    return llvm::ConstantArray::get(arrayLLVMType, constInitValues);
}

llvm::BasicBlock* IRGenerator::createBasicBlock(
    llvm::Function* function,
    const std::string& name
) {
    // 创建基本块并插入到函数末尾
    llvm::BasicBlock* bb = llvm::BasicBlock::Create(
        builder.getContext(),
        name,
        function
    );
    
    // 设置插入点到新创建的基本块
    builder.SetInsertPoint(bb);
    
    return bb;
}

llvm::Value* IRGenerator::generateFlatArrayInit(const SymType& arrayType, 
                                              const std::vector<llvm::Value*>& initValues, std::string Ident) {
    auto& builder = getBuilder();
    llvm::Type* elemType = getLLVMType(arrayType);
    
    // 计算总元素数量
    size_t totalElements = 1;
    for (int dim : arrayType.array_dims) {
        totalElements *= dim;
    }
    
    // 创建数组类型
    llvm::ArrayType* arrayLLVMType = llvm::ArrayType::get(elemType, totalElements);
    
    // 处理全局变量和局部变量的不同情况
    if (builder.GetInsertBlock() == nullptr) {
        // 全局变量初始化
        std::vector<llvm::Constant*> constInitValues;
        
        // 填充提供的初始化值
        for (auto val : initValues) {
            constInitValues.push_back(llvm::cast<llvm::Constant>(val));
        }
        
        // 填充剩余元素为0
        llvm::Value* zeroVal = getZeroValue(arrayType.base_type);
        llvm::Constant* zero = llvm::cast<llvm::Constant>(zeroVal);
        for (size_t i = initValues.size(); i < totalElements; ++i) {
            constInitValues.push_back(zero);
        }
        
        return llvm::ConstantArray::get(arrayLLVMType, constInitValues);
    } else {
        // 局部变量初始化
        llvm::Value* arrayAlloc = builder.CreateAlloca(arrayLLVMType, nullptr, "array.init");
        
        // 存储初始化值
        for (size_t i = 0; i < initValues.size(); ++i) {
            std::vector<llvm::Value*> indices = {
                builder.getInt32(0),  // 第一个维度索引
                builder.getInt32(i)    // 元素索引
            };
            
            llvm::Value* elemPtr = builder.CreateInBoundsGEP(
                arrayAlloc->getType()->getPointerElementType(),
                arrayAlloc,
                indices,
                "array.elem");
                
            builder.CreateStore(initValues[i], elemPtr);
        }
        
        // 填充剩余元素为0
        llvm::Value* zero = getZeroValue(arrayType.base_type);
        for (size_t i = initValues.size(); i < totalElements; ++i) {
            std::vector<llvm::Value*> indices = {
                builder.getInt32(0),
                builder.getInt32(i)
            };
            
            llvm::Value* elemPtr = builder.CreateInBoundsGEP(
                arrayAlloc->getType()->getPointerElementType(),
                arrayAlloc,
                indices,
                "array.elem");
                
            builder.CreateStore(zero, elemPtr);
        }
        
        return arrayAlloc;
    }
}