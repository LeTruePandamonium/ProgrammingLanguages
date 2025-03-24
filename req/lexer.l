%{
#include <stdio.h>
%}

/* Define token patterns */
DIGIT   [0-9]+
ID      [a-zA-Z_][a-zA-Z0-9_]*
OP      [+\-*/=]

%%

{DIGIT}    { printf("NUMBER(%s)\n", yytext); }
{ID}       { printf("IDENTIFIER(%s)\n", yytext); }
{OP}       { printf("OPERATOR(%s)\n", yytext); }
[\t\n ]+   { /* Ignore whitespace */ }
.          { printf("UNKNOWN(%s)\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
