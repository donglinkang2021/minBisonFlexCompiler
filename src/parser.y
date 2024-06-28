
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
%token <strval>     IDENTIFIER
%token <strval>     INT_NUMBER

%type <strval> func_def

%type <strval> statement
%type <strval> sentence 

%type <strval> decl_stmt
%type <intval> type_dec
%type <strval> id_list
%type <strval> id_elem

%type <strval> return_stmt 
%type <strval> assign_stmt
%type <strval> expr 
%type <strval> factor 

%start func_def

// Precedence and associativity

%left '='
%left OR
%left AND
%left '|'
%left '^'
%left '&'
%left EQ NE
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/' '%'
%left NEG POS '!' '~'

%%

// Grammar rules

func_def
    : type_dec IDENTIFIER '(' ')' '{' statement '}' 
    { 
        printf("FUNC_DEF\n"); 
        printf("%s\n", $6); 
    }

statement
    : sentence ';'              
    { 
        printf("---STMT---\t"); 
        printf("%s;\n", $1); 
        $$ = concat($1, " ", ";\n");
    }
    | statement sentence ';'    
    { 
        printf("---STMT---\t"); 
        printf("%s;\n", $2); 
        $$ = concat($1, $2, ";\n");
    }
;

sentence
    : decl_stmt         { $$ = $1; }
    | assign_stmt       { $$ = $1; }
    | return_stmt       { $$ = $1; }
    | %empty            { $$ = 0; }
;

decl_stmt
    : type_dec id_list  
    { 
        printf("DECL\t"); 
        $$ = concat(itoType($1), " ", $2); 
        printf("%s\n", $$);
    }

type_dec
    : INT               { $$ = 1; }
    | VOID              { $$ = 2; }

id_list
    : id_elem ',' id_list   
    { 
        $$ = concat($1, ",", $3); 
        printf("%s\n", $$); 
    }
    | id_elem               { $$ = $1; }

id_elem
    : IDENTIFIER              { $$ = $1; }
    | assign_stmt           { $$ = $1; }

assign_stmt
    : IDENTIFIER '=' expr  
    { 
        printf("ASSIGN\t"); 
        $$ = concat($1, "=", $3); 
        printf("%s\n", $$); 
    }

expr
    : expr '+' expr         
    { 
        printf("ADD\t"); 
        $$ = concat($1, "+", $3); 
        printf("%s\n", $$); 
    }
    | expr '-' expr         
    { 
        printf("SUB\t"); 
        $$ = concat($1, "-", $3); 
        printf("%s\n", $$); 
    }
    | expr '*' expr         
    { 
        printf("MUL\t"); 
        $$ = concat($1, "*", $3); 
        printf("%s\n", $$); 
    }
    | expr '/' expr         
    { 
        printf("DIV\t"); 
        $$ = concat($1, "/", $3); 
        printf("%s\n", $$); 
    }
    | expr '%' expr         
    { 
        printf("MOD\t"); 
        $$ = concat($1, "%", $3); 
        printf("%s\n", $$); 
    }
    | '(' expr ')'          
    { 
        printf("PAREN\t"); 
        $$ = concat("(", $2, ")"); 
        printf("%s\n", $$); 
    }
    | '-' expr %prec NEG    
    { 
        printf("NEG\t"); 
        $$ = concat("-", $2, ""); 
        printf("%s\n", $$); 
    }
    | '+' expr %prec POS    
    { 
        printf("POS\t"); 
        $$ = concat("+", $2, ""); 
        printf("%s\n", $$); 
    }
    | factor                { $$ = $1;}

factor
    : INT_NUMBER        
    { 
        printf("INTEGER \t%s\n", $1);
    }
    | IDENTIFIER          
    { 
        printf("IDENTIFIER\t%s\n", $1);
    }

return_stmt
    : RETURN expr       
    { 
        printf("RETURN\t"); 
        $$ = concat("return", " ", $2); 
        printf("%s\n", $$); 
    }

%%

