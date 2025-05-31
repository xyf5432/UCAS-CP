// #include "antlr4-runtime.h"

#include "Analysis.h"

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

  auto tree = parser.compUnit();

  if (parser.getNumberOfSyntaxErrors() > 0) {
      std::cerr << "Compilation failed due to syntax errors." << std::endl;
      return 1;
  }

  Analysis visitor;
  visitor.visit( tree );
  return 0;
}