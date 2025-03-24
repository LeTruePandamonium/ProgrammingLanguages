%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

expr: expr '+' expr  { printf("RESULT: %d\n", $1 + $3); }
    | expr '-' expr  { printf("RESULT: %d\n", $1 - $3); }
    | expr '*' expr  { printf("RESULT: %d\n", $1 * $3); }
    | expr '/' expr  { if ($3 == 0) { yyerror("Division by zero!"); }
                        else { printf("RESULT: %d\n", $1 / $3); } }
    | '(' expr ')'   { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | NUMBER         { $$ = $1; }
    | error          { yyerror("Syntax Error: Invalid expression"); yyclearin; }
    ;

%%

int main() {
    printf("Enter an expression: ");
    yyparse();
    return 0;
}


void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
