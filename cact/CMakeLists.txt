cmake_minimum_required(VERSION 3.5)

project(Compiler LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(THREADS_PREFER_PTHREAD_FLAG ON)

# 设置LLVM安装路径
set(LLVM_DIR "/home/compiler14/llvm-10/lib/cmake/llvm")

# 查找LLVM包
find_package(LLVM 10.0 REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# 添加LLVM相关设置
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})
link_directories(${LLVM_LIBRARY_DIRS})

# 获取需要的LLVM组件
llvm_map_components_to_libnames(llvm_libs
    Core
    Support
    IRReader
    Analysis
    ExecutionEngine
    MC
    Object
    RuntimeDyld
    TransformUtils
    BitReader
    BitWriter
    Linker
    Target
    Passes
)

# 添加ANTLR相关设置
include_directories(deps/antlr4-runtime/)
include_directories(grammar)
include_directories(src)

# 查找线程库
find_package(Threads REQUIRED)

# 收集源文件
file(GLOB_RECURSE SOURCE_FILES "src/*.cpp" "grammar/*.cpp")
file(GLOB_RECURSE ANTLR_LIB_FILES "deps/antlr4-runtime/*.cpp")

# 添加编译选项
add_definitions(-w -g)

# 构建ANTLR静态库
add_library(antlr STATIC ${ANTLR_LIB_FILES})

# 构建主程序
add_executable(compiler ${SOURCE_FILES})

# 链接库
target_link_libraries(compiler 
    antlr 
    ${llvm_libs}
    Threads::Threads
    ${LLVM_SYSTEM_LIBS}
)

# 添加LLVM链接选项
if(LLVM_LINK_LLVM_DYLIB)
    target_link_options(compiler PRIVATE "-fuse-ld=lld")
endif()
