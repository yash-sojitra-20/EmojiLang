%{
#include "parser.tab.h"
%}

%%  /* Regular Expressions for Tokens */

"🔢"          { return NUMBER; }
"📦"          { return INTEGER; }
"🎁"          { return FLOAT; }
[0-9]+        { yylval.intval = atoi(yytext); return INT_VAL; }
[0-9]+"."[0-9]+   { yylval.floatval = atof(yytext); return FLOAT_VAL; }
";"          { return SEMICOLON; }
[ \t\n]+     { /* Ignore whitespace */ }
.            { printf("Unknown Token: %s\n", yytext); return 0; }

%%

int yywrap() {
    return 1;
}