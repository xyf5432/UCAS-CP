grammar CACT;

@header {
    #include <vector>
}

// 编译单元
compUnit
    : (decl | funcDef)+
    ;

// 声明
decl
    : constDecl
    | varDecl
    ;

// 常量声明
constDecl
    : 'const' bType constDef (',' constDef)* ';'
    ;

// 基本类型
bType
    : 'int'
    | 'float'
    | 'char'
    ;

// 常量定义
constDef
    : Ident ('[' IntConst ']')* '=' constInitVal
    ;

// 常量初始化
constInitVal
    : constExp
    | '{' (constInitVal (',' constInitVal)*)? '}'
    ;

// 变量声明
varDecl
    : bType varDef (',' varDef)* ';'
    ;

// 变量定义
varDef
    : Ident ('[' IntConst ']')* ('=' constInitVal)?
    ;

// 函数定义
funcDef
    : funcType Ident '(' (funcFParams)? ')' block
    ;

// 函数类型
funcType
    : 'void'
    | 'int'
    | 'float'
    | 'char'
    ;

// 函数形参列表
funcFParams
    : funcFParam (',' funcFParam)*
    ;

// 函数形参
funcFParam
    : bType Ident ('[' (IntConst)? ']' ('[' IntConst ']')* )?
    ;

// 语句块
block
    : '{' blockItem* '}'
    ;

// 语句块项
blockItem
    : decl
    | stmt
    ;

// 语句
stmt
    : lVal '=' exp ';'                         # assignStmt
    | (exp)? ';'                               # exprStmt
    | block                                    # blockStmt
    | 'return' exp? ';'                        # returnStmt
    | 'if' '(' cond ')' stmt ('else' stmt)?    # ifStmt
    | 'while' '(' cond ')' stmt                # whileStmt
    | 'break' ';'                              # breakStmt
    | 'continue' ';'                           # continueStmt
    ;

// 表达式
exp
    : addExp
    ;

// 常量表达式
constExp
    : addExp
    ;

// 条件表达式
cond
    : lOrExp
    ;

// 左值
lVal
    : Ident ('[' exp ']')*
    ;

// 数值
number
    : IntConst
    | FloatConst
    | CharConst
    ;

// 函数实参
funcRParams
    : exp (',' exp)*
    ;

// 基础表达式
primaryExp
    : '(' exp ')'
    | lVal
    | number
    ;

// 单目表达式
unaryExp
    : primaryExp                                                                       # primaryUnary
    | ('+' | '-' | '!') unaryExp                                                       # unaryOp
    | Ident '(' (funcRParams)? ')'                                                     # funcCall
    ;

// 乘除模表达式
mulExp
    : unaryExp                                                                         # unaryToMul
    | mulExp ('*' | '/' | '%') unaryExp                                               # mulOp
    ;

// 加减表达式
addExp
    : mulExp                                                                           # mulToAdd
    | addExp ('+' | '-') mulExp                                                       # addOp
    ;

// 关系表达式
relExp
    : addExp                                                                           # addToRel
    | relExp ('<' | '>' | '<=' | '>=') addExp                                         # relOp
    ;

// 相等性表达式
eqExp
    : relExp                                                                           # relToEq
    | eqExp ('==' | '!=') relExp                                                      # eqOp
    ;

// 逻辑与表达式
lAndExp
    : eqExp                                                                            # eqToLAnd
    | lAndExp '&&' eqExp                                                              # lAndOp
    ;

// 逻辑或表达式
lOrExp
    : lAndExp                                                                          # lAndToLOr
    | lOrExp '||' lAndExp                                                             # lOrOp
    ;



// 词法规则
Ident
    : [a-zA-Z_] [a-zA-Z0-9_]*
    ;

IntConst
    : [+-]? DecimalConst
    | [+-]? OctalConst
    | [+-]? HexadecConst
    ;

FloatConst
    : [+-]? Digit+ '.' Digit*    // 普通形式：如123.45、123.
    | [+-]? '.' Digit+          // 普通形式：如.45
    | [+-]? ( ( Digit+ ('.' Digit*)? | '.' Digit+ ) // 基数部分
          [Ee] [+-]? Digit+)                     // 指数部分
      [fF]
    ;

//' '内转义或其他字符（排除需要转义的字符）
CharConst
    : '\'' (EscapeChar | ~['\\\r\n]) '\''
    ;

// 空白和注释
NewLine
    : ('\r\n'
    | '\r'
    | '\n') -> skip
    ;

WhiteSpace
    : (' '
    | '\t') -> skip
    ;

LineComment
    : '//' (~[\r\n])* -> skip
    ;

//非贪婪模式匹配
BlockComment
    : '/*' .*? '*/' -> skip
    ;

// 辅助词法规则
fragment DecimalConst
    : '0'
    | [1-9] [0-9]*
    ;

fragment OctalConst
    : '0' [0-7]*
    ;

fragment HexadecConst
    : '0' [xX] [0-9a-fA-F]+
    ;

fragment EscapeChar
    : '\\' [nt\\'"0]
    ;

fragment Digit
    : [0-9]
    ;