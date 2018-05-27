
%{
  #include "parser.tab.h"
  extern void yyerror();
  extern int yylineno;
  extern int errorCount;
  extern int success();

%}

%x COMMENT_MULTI 

%%

<INITIAL>"/*"               { BEGIN(COMMENT_MULTI);}
<COMMENT_MULTI>"*/"         {BEGIN(INITIAL);}
<COMMENT_MULTI><<EOF>>      {
                              yyerror("Unclosed Comment!");
                              exit(EXIT_FAILURE);
                            }
<COMMENT_MULTI>.            ;

"if"                        return IF;
"else"                      return ELSE;
"int"                       return INT;
"return"                    return RETURN;
"void"                      return VOID;
"while"                     return WHILE;
"+"                         return PLUS;
"-"                         return MINUS;
"*"                         return MULTIPLY;
"/"                         return DIVIDE;
"<"                         return LESS_THAN;
"<="                        return LESS_OR_EQUAL;                     
">"                         return GREATER_THAN;
">="                        return GREATER_OR_EQUAL;
"=="                        return EQUALS;
"!="                        return NOT_EQUALS;
"="                         return ASSIGNMENT;
";"                         return EOL;
","                         return COMMA;
"{"                         return LEFT_PARANTHESIS;
"}"                         return RIGHT_PARANTHESIS;
"("                         return LEFT_BRACKET;
")"                         return RIGHT_BRACKET;
"["                         return LEFT_SQR_BRACKET;
"]"                         return RIGHT_SQR_BRACKET;
[a-zA-Z][a-zA-Z]*           return ID;
[0-9]+                      return NUM;
[ \t\r]+                    ;
[\n]                        {yylineno++;}
.                           {yyerror("Error in Syntax");}

%%

int yywrap(void){
    return 1;
}
  