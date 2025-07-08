#!/bin/bash

# --- 配置部分 ---
# 项目根目录
PROJECT_ROOT="/home/compiler14/compiler14"

# **修改：指定官方标准库路径**
LIBCAC_PATH="/opt/ucascompiler/libcact/libcact_riscv32.a"

# 编译器可执行文件路径
COMPILER_PATH="$PROJECT_ROOT/cact/build/compiler"

# 测试用例目录
TESTCASE_DIR="$PROJECT_ROOT/cact/test/testcases-main/functional"
INPUT_DIR="$PROJECT_ROOT/cact/test/testcases-main/functional"
ANSWER_DIR="$PROJECT_ROOT/cact/test/testcases-main/functional"

# 存放汇编文件和可执行文件的目录
RESULT_DIR="$PROJECT_ROOT/result"

# RISC-V 工具链前缀
RISCV_PREFIX="riscv32-unknown-linux-gnu"
RISCV_GCC="${RISCV_PREFIX}-gcc"

# 模拟器
SIMULATOR="spike pk"

# --- 颜色定义 (可选，用于美化输出) ---
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_NC='\033[0m' # No Color

# --- 脚本主体 ---

# 检查并创建结果目录
if [ ! -d "$RESULT_DIR" ]; then
    echo -e "${COLOR_YELLOW}Creating result directory: $RESULT_DIR${COLOR_NC}"
    mkdir -p "$RESULT_DIR"
fi

# 清理之前的结果
echo "Cleaning up previous results in $RESULT_DIR..."
rm -f "$RESULT_DIR"/*.s "$RESULT_DIR"/*.o "$RESULT_DIR"/*.txt "$RESULT_DIR"/*

# 检查编译器是否存在
if [ ! -x "$COMPILER_PATH" ]; then
    echo -e "${COLOR_RED}Error: Compiler not found or not executable at $COMPILER_PATH${COLOR_NC}"
    echo "Please build your compiler in cact/build first."
    exit 1
fi

# **新增：检查官方标准库是否存在**
if [ ! -f "$LIBCAC_PATH" ]; then
    echo -e "${COLOR_RED}Error: Standard library not found at $LIBCAC_PATH${COLOR_NC}"
    echo "Please make sure the official libcact_riscv32.a is in the correct path."
    exit 1
fi

# 统计成功和失败的案例
total_cases=0
passed_cases=0
failed_cases=0

# 遍历所有测试用例 (00 到 33)
for i in $(seq -w 00 33); do
    test_name="$i"
    cact_file="${TESTCASE_DIR}/${test_name}.cact"
    s_file="${RESULT_DIR}/${test_name}.s"
    out_file="${RESULT_DIR}/${test_name}.out"
    txt_file="${RESULT_DIR}/${test_name}.txt"
    executable_file="${RESULT_DIR}/${test_name}"
    answer_file="${ANSWER_DIR}/${test_name}.out"
    input_file="${INPUT_DIR}/${test_name}.in"

    total_cases=$((total_cases + 1))
    echo "----------------------------------------------------"
    echo -e "Testing ${COLOR_YELLOW}${test_name}.cact${COLOR_NC}..."

    rm -f "$PROJECT_ROOT/cact/build/output.s" "$PROJECT_ROOT/cact/build/output.txt"

    # 1. 编译 .cact 文件生成 output.s (不变)
    cd "$PROJECT_ROOT/cact/build"
    "$COMPILER_PATH" "$cact_file" > /dev/null 2> "$RESULT_DIR/compiler_error.log"
    if [ ! -f "output.s" ] || [ -s "$RESULT_DIR/compiler_error.log" ]; then
        echo -e "${COLOR_RED}FAIL: Compiler failed to generate assembly.${COLOR_NC}"
        echo "Compiler Error:" >> "$txt_file"
        cat "$RESULT_DIR/compiler_error.log" >> "$txt_file"
        failed_cases=$((failed_cases + 1))
        rm -f "$RESULT_DIR/compiler_error.log"
        continue
    fi
    rm -f "$RESULT_DIR/compiler_error.log"

    # 2. 拷贝并重命名汇编文件 (不变)
    mv "output.s" "$s_file"

    # 切换到结果目录
    cd "$RESULT_DIR"

    # 3. 汇编 .s 文件并链接官方标准库
    echo "Assembling $s_file and linking with libcact_riscv32.a..."
    # **核心修改：在链接命令中直接使用 .a 文件**
    ${RISCV_GCC} -static -o "$executable_file" "$s_file" "$LIBCAC_PATH" > "$txt_file" 2>&1
    
    if [ $? -ne 0 ]; then
        echo -e "${COLOR_RED}FAIL: Assembler/Linker (gcc) failed.${COLOR_NC}"
        echo "Assembler/Linker error is recorded in ${test_name}.txt"
        failed_cases=$((failed_cases + 1))
        continue
    fi

    # 4. 运行可执行文件 (不变)
    echo "Running on simulator..."
    run_command="$SIMULATOR ./${test_name}"
    if [ -f "$input_file" ]; then
        echo "Found input file: ${input_file}. Redirecting stdin."
        run_command="$SIMULATOR ./${test_name} < ${input_file}"
    fi
    {
        eval "$run_command" > "$out_file" 2>&1
        exit_code=$?
        printf "\n" >> "$out_file"
        echo "$exit_code" >> "$out_file"
    }
    
    # 检查spike是否执行成功
    # (这部分逻辑保持不变)
    if [ -s "$out_file" ] && grep -q "z  " "$out_file"; then
        echo -e "${COLOR_RED}FAIL: Simulator (spike) reported an error.${COLOR_NC}"
        mv "$out_file" "$txt_file"
        echo "Simulator error is recorded in ${test_name}.txt"
        failed_cases=$((failed_cases + 1))
        continue
    fi
    
    # 5. 比对结果
    # (这部分逻辑保持不变)
    if [ ! -f "$answer_file" ]; then
        echo -e "${COLOR_YELLOW}WARN: Answer file ${answer_file} not found. Skipping comparison.${COLOR_NC}"
        continue
    fi

    echo "Comparing output with ${answer_file}..."
    diff -wB "$out_file" "$answer_file" > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}PASS: Output matches the answer.${COLOR_NC}"
        passed_cases=$((passed_cases + 1))
        rm -f "$txt_file" "$out_file"
    else
        echo -e "${COLOR_RED}FAIL: Output mismatch.${COLOR_NC}"
        echo "Difference is recorded in ${test_name}.txt"
        diff -wB "$out_file" "$answer_file" > "$txt_file"
        failed_cases=$((failed_cases + 1))
    fi
done

# --- 总结报告 (不变) ---
echo "===================================================="
echo "Test Summary:"
echo -e "Total: ${total_cases}, ${COLOR_GREEN}Passed: ${passed_cases}${COLOR_NC}, ${COLOR_RED}Failed: ${failed_cases}${COLOR_NC}"
echo "===================================================="

if [ $failed_cases -gt 0 ]; then
    exit 1
fi

exit 0