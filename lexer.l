%{
#include "parser.tab.h"
#include <stdio.h>
#include <string.h>

int line_num = 1;
%}

%%

"TASK"          { return TASK; }
"RUN"           { return RUN; }
"EVERY"         { return EVERY; }
"DAY"           { return DAY; }
"WEEK"          { return WEEK; }
"ON"            { return ON; }
"AT"            { return AT; }
"AFTER"         { return AFTER; }
"IF"            { return IF; }
"success"       { return SUCCESS; }
"failure"       { return FAILURE; }
"DEPENDS"       { return DEPENDS; }

"MONDAY"        { yylval.str = strdup(yytext); return DAYNAME; }
"TUESDAY"       { yylval.str = strdup(yytext); return DAYNAME; }
"WEDNESDAY"     { yylval.str = strdup(yytext); return DAYNAME; }
"THURSDAY"      { yylval.str = strdup(yytext); return DAYNAME; }
"FRIDAY"        { yylval.str = strdup(yytext); return DAYNAME; }
"SATURDAY"      { yylval.str = strdup(yytext); return DAYNAME; }
"SUNDAY"        { yylval.str = strdup(yytext); return DAYNAME; }

[0-9]{2}:[0-9]{2}          { yylval.str = strdup(yytext); return TIME; }
\"[^\"]*\"                 { yylval.str = strdup(yytext); return STRING; }
[a-zA-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); return IDENTIFIER; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }

[ \t\r]+        { /* skip whitespace */ }
\n              { line_num++; }
"#"[^\n]*       { /* skip comments */ }

.               {
                    fprintf(stderr, "Lexical Error: Unknown character '%s' at line %d\n", yytext, line_num);
                }

%%

int yywrap() { return 1; }
