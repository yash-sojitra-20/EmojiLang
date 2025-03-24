%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
int yylex(void);
%}

/* Define value types */
%union {
    int intval;
    float floatval;
}

/* Tokens */
%token NUMBER INTEGER FLOAT SEMICOLON
%token <intval> INT_VAL
%token <floatval> FLOAT_VAL

/* Specify types for non-terminals */
%type <intval> type
%type <floatval> value

%%  /* Grammar Rules */

program: 
        program statement { /* This allows multiple statements */ }
      | statement
      ;

statement: NUMBER type value SEMICOLON {  
                if ($2 == INTEGER && $3 == (int)$3) {
                    printf("Valid: INTEGER value.\n");
                } else if ($2 == FLOAT && $3 != (int)$3) {
                    printf("Valid: FLOAT value.\n");
                } else {
                    if ($2 == INTEGER && $3 != (int)$3) {
                        printf("Error: Expecting INTEGER but entered FLOAT value.\n");
                    } else if ($2 == FLOAT && $3 == (int)$3) {
                        printf("Error: Expecting FLOAT but entered INTEGER value.\n");
                    } else {
                        printf("Error: Type mismatch.\n");
                    }
                    YYABORT;
                }
            }
        | NUMBER type value error  { printf("Error: Missing semicolon at the end.\n"); YYABORT; }
        | error { printf("Error: Invalid statement.\n"); YYABORT; }
        ;

type: INTEGER   { $$ = INTEGER; }
    | FLOAT     { $$ = FLOAT; }
    ;

value: INT_VAL       { $$ = (float) $1; }  /* Convert INT to FLOAT */
     | FLOAT_VAL     { $$ = $1; }
     ;

%%  /* C Functions */

int main() {
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
        return 0;
    } else {
        return 1;
    }
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}