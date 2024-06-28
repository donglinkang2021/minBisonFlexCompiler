/* filename -> scanner.l */
%option noyywrap yylineno

%{
#include <stdio.h>   
#include <stdlib.h>
#include <string.h>
#include "parser.h"
int old_status;
void yyerror(char *s, ...);

%}

%x COMMENT

%%
	/* regex */
int         { return INT; }
void        { return VOID; }
if          { return IF; }
else        { return ELSE; }
while       { return WHILE; }
for         { return FOR; }
break       { return BREAK; }
continue    { return CONTINUE; }
return      { return RETURN; }
	
	/* user variable */
[a-zA-Z][a-zA-Z0-9_]*       { yylval.strval = strdup(yytext); return IDENTIFIER; }
	/* integer numbers */
-?[0-9]+                    { yylval.strval = strdup(yytext); return INT_NUMBER; }
	/* C-type strings */
\"(\\.|[^"\n])*$            { yyerror("Unterminated string %s", yytext); }

    /* operators */
[-+&~|&^/%*(){},.;!~<>=]       { return yytext[0]; }
"&&"                    { return AND; }
"||"                    { return OR; }
"=="                    { return EQ; }
"!="                    { return NE; }
"<="                    { return LE; }
">="                    { return GE; }

    /* comments */
"//".*;
"/*"                    { old_status = YY_START; BEGIN COMMENT; }
<COMMENT>"*/"           { BEGIN old_status; }
	/* space & tab */
[ \t\n]
	/* prevent flex jam */
.           { yyerror("something goes wrong...\n"); }

%%

