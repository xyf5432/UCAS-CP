// #include "antlr4-runtime.h"

#include "Analysis.h"
#include "RISCVCodeGenerator.h"

using namespace antlr4;

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

  // --- 关键修改：启用 SLL 解析模式 ---
  // 1. 设置解析器的解释模式为 SLL
  parser.getInterpreter<atn::ParserATNSimulator>()->setPredictionMode(atn::PredictionMode::SLL);

  // 2. 移除默认的错误监听器，这样它就不会在遇到 SLL 歧义时打印错误
  parser.removeErrorListeners();

  try {
      auto tree = parser.compUnit(); // 在 SLL 模式下解析

      // 如果 SLL 成功，我们就可以继续
      Analysis visitor;
      visitor.visit( tree );
      
      // ... (后续的 IR 生成和 RISC-V 生成) ...

  } catch (const ParseCancellationException &ex) {
      // 如果 SLL 失败，说明可能存在真正的歧义。
      // 我们可以回退到更强大的 LL 模式再试一次。
      tokens.reset(); // 重置 token 流
      parser.reset();

      // 使用默认的错误处理器
      parser.setErrorHandler(std::make_shared<DefaultErrorStrategy>());
      // 添加回默认的错误监听器
      parser.addErrorListener(&ConsoleErrorListener::INSTANCE);
      // 切换回 LL 模式
      parser.getInterpreter<atn::ParserATNSimulator>()->setPredictionMode(atn::PredictionMode::LL);
      
      auto tree = parser.compUnit(); // 在 LL 模式下重新解析

      if (parser.getNumberOfSyntaxErrors() > 0) {
          std::cerr << "Compilation failed due to syntax errors." << std::endl;
          return 1;
      }
      
      // LL 模式成功，继续
      Analysis visitor;
      visitor.visit( tree );

      // 1. 获取已经生成好的 LLVM Module
      llvm::Module* module = visitor.getIRGenerator().getModule();

      // 2. 验证模块的正确性 (好习惯)
      //if (llvm::verifyModule(*module, &llvm::errs())) {
      //    std::cerr << "LLVM Module verification failed. Aborting." << std::endl;
      //    return 1;
      //}

      // 3. 创建并运行你的 RISC-V 代码生成器
      RISCVCodeGenerator riscv_gen;
      riscv_gen.generate(module, "output.s"); // "output.s" is the final assembly file

      std::cout << "RISC-V assembly generated in output.s" << std::endl;
  } 
  return 0;
}