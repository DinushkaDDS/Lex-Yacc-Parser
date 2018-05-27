%{
  #include <stdarg.h>
  #include <stdio.h>
  extern int yylineno;
  //extern int yydebug = 1;    Use this to enable the debug mode of lex
  void yyerror();
  int yylex();
  int success();
  int errorCount = 0;
  #define YYERROR_VERBOSE 1;
%}


// Tokens Definition to Hadle in the Grammar
%token START_OF_COMMENT
%token END_OF_COMMENT
%token IF
%token ELSE
%token INT
%token RETURN
%token VOID
%token WHILE
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token LESS_THAN
%token LESS_OR_EQUAL
%token GREATER_THAN
%token GREATER_OR_EQUAL
%token EQUALS

%token ASSIGNMENT
%token NOT_EQUALS
%token EOL
%token COMMA
%token LEFT_PARANTHESIS
%token RIGHT_PARANTHESIS
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_SQR_BRACKET
%token RIGHT_SQR_BRACKET
%token ID
%token NUM

/*Grammar Rules Implementation*/

%%
program: declaration-list;
declaration-list: declaration-list declaration | declaration|error EOL| error RIGHT_PARANTHESIS;
declaration: var-declaration | fun-declaration|error EOL| error RIGHT_PARANTHESIS;
var-declaration: type-specifier ID EOL | type-specifier ID LEFT_SQR_BRACKET NUM RIGHT_SQR_BRACKET EOL |error EOL;
type-specifier: INT | VOID|error EOL| error RIGHT_PARANTHESIS;
fun-declaration: type-specifier ID LEFT_BRACKET params RIGHT_BRACKET compound-stmt;
params: param-list | VOID|error EOL| error RIGHT_PARANTHESIS;
param-list: param-list COMMA param | param|error EOL| error RIGHT_PARANTHESIS;
param: type-specifier ID | type-specifier ID LEFT_SQR_BRACKET RIGHT_SQR_BRACKET|error EOL| error RIGHT_PARANTHESIS;
compound-stmt: LEFT_PARANTHESIS local-declarations statement-list RIGHT_PARANTHESIS|error EOL| error RIGHT_PARANTHESIS;
local-declarations: local-declarations var-declaration | %empty|error EOL| error RIGHT_PARANTHESIS;
statement-list: statement-list statement | %empty;
statement: expression-stmt | compound-stmt | selection-stmt | iteration-stmt |
return-stmt;
expression-stmt: expression EOL | EOL;
selection-stmt: IF LEFT_BRACKET expression RIGHT_BRACKET statement | IF LEFT_BRACKET expression RIGHT_BRACKET statement ELSE
statement;
iteration-stmt: WHILE LEFT_BRACKET expression RIGHT_BRACKET statement;
return-stmt: RETURN EOL | RETURN expression EOL;
expression: var ASSIGNMENT expression | simple-expression|error EOL| error RIGHT_PARANTHESIS;
var: ID | ID LEFT_SQR_BRACKET expression RIGHT_SQR_BRACKET|error EOL| error RIGHT_PARANTHESIS;
simple-expression: additive-expression relop additive-expression | additive-expression;
relop: LESS_THAN | LESS_OR_EQUAL | GREATER_THAN | GREATER_OR_EQUAL | EQUALS | NOT_EQUALS|error EOL| error RIGHT_PARANTHESIS;
additive-expression: additive-expression addop term | term;
addop: PLUS | MINUS|error EOL| error RIGHT_PARANTHESIS;
term: term mulop factor | factor;
mulop: MULTIPLY | DIVIDE|error EOL| error RIGHT_PARANTHESIS;
factor: LEFT_BRACKET expression RIGHT_BRACKET | var | call | NUM;
call: ID LEFT_BRACKET args RIGHT_BRACKET;
args: arg-list | %empty;
arg-list: arg-list COMMA expression | expression;

%%    
//Functions to handle the main functionalities fo the Parser

int main (void) {
  yyparse();
  success();
}

//Function to handle error
void yyerror(char const *s) {
      fprintf(stderr, "line %d: %s\n", yylineno, s);
      errorCount++;
}

//Checking number of errors of the Document to find the Success of the Parser.
int success(void){
  if(errorCount==0){
    fprintf(stderr, "Successfully Parsed!\n");
    return 1;
  }
}
