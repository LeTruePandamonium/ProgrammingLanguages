%{
#include <stdio.h>
#include "parser.tab.h"

void yyerror(const char *s);
%}

%%

[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[+\-*/()]   { return yytext[0]; }
[ \t\n]     { /* Ignore whitespace */ }
.           { printf("Lexical Error: Unrecognized character '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}
