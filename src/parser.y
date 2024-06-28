
%code top {
    #include <stdio.h>
    #include "utils.h"
    extern int yylex(void);
}

// Terminals


%debug

%locations

%union {
    int intval;
    char *strval;
}

%token INT
%token VOID
%token IF
%token ELSE
%token WHILE
%token FOR
%token BREAK
%token CONTINUE
%token RETURN
%token <strval>     IDENTITY
%token <strval>     INT_NUMBER

%type <intval> type_dec
%type <strval> expr decl_stmt factor sentence id_list assign_stmt

%start statement

// Precedence and associativity

%left OR
%left AND
%left '='
%left '+' '-'
%left '*' '/' '%'
%left '!'
%left NEG

%%

// Grammar rules

statement
    : sentence ';'    { printf("STMT\n"); }
    | statement sentence ';'
;

sentence
    : decl_stmt         { $$ = $1; }
    | assign_stmt       { $$ = $1; }
    | %empty            { $$ = 0; }
;

decl_stmt
    : type_dec id_list  { printf("DECL\n"); }

type_dec
    : INT               { $$ = 1; }
    | VOID              { $$ = 2; }

id_list
    : IDENTITY              { printf("ID\n"); }
    | id_list ',' IDENTITY  { printf("ID\n"); }

assign_stmt
    : IDENTITY '=' expr  { printf("ASSIGN\t"); printf("%s\n", concat($1, "=", $3)); }

expr
    : expr '+' expr         { printf("ADD\t"); $$ = concat($1, "+", $3); printf("%s\n", $$); }
    | expr '-' expr         { printf("SUB\t"); $$ = concat($1, "-", $3); printf("%s\n", $$); }
    | expr '*' expr         { printf("MUL\t"); $$ = concat($1, "*", $3); printf("%s\n", $$); }
    | expr '/' expr         { printf("DIV\t"); $$ = concat($1, "/", $3); printf("%s\n", $$); }
    | expr '%' expr         { printf("MOD\t"); $$ = concat($1, "%", $3); printf("%s\n", $$); }
    | '(' expr ')'          { printf("PAREN\t"); $$ = concat("(", $2, ")"); printf("%s\n", $$); }
    | '-' expr %prec NEG    { printf("NEG\t"); $$ = concat("-", $2, ""); printf("%s\n", $$); }
    | factor                { $$ = $1;                      }

factor
    : INT_NUMBER        { printf("INTEGER \t%s\n", $1);}
    | IDENTITY          { printf("IDENTITY\t%s\n", $1);}

%%

