
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

%type <strval> program
%type <strval> function
%type <strval> parameter
%type <strval> argument

%type <strval> statements
%type <strval> statement
%type <strval> sentence 

%type <strval> decl_stmt
%type <intval> type_dec
%type <strval> id_list
%type <strval> id_elem

%type <strval> return_stmt 
%type <strval> assign_stmt
%type <strval> call_stmt
%type <strval> expr 
%type <strval> factor 

%type <strval> if_stmt
%type <strval> while_stmt

%start program

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

program
    : function
    { 
        printf("function\n");
        printf("%s\n", $1); 
    }
    | program function
    { 
        printf("function\n");
        printf("%s\n", $2); 
    }
    ;

function
    : type_dec IDENTIFIER '(' parameter ')' '{' statements '}' 
    { 
        char* func_def = concat(itoType($1), " ", $2);
        char* func_params = concat("(", $4, ")");
        char* func_body = concat("{\n", $7, "\n}");
        $$ = concat(func_def, func_params, func_body);
    }
    ;

parameter
    : %empty
    { 
        $$ = " "; 
    }
    | type_dec IDENTIFIER
    { 
        printf("parameter\t"); 
        $$ = concat(itoType($1), " ", $2); 
        printf("%s\n", $$); 
    }
    | parameter ',' type_dec IDENTIFIER
    { 
        printf("parameter\t"); 
        char* para1 = $1;
        char* para2 = concat(itoType($3), " ", $4);
        $$ = concat(para1, ", ", para2); 
        printf("%s\n", $$); 
    }
    ;

argument
    : %empty
    { 
        $$ = " "; 
    }
    | expr
    { 
        $$ = $1; 
    }
    | argument ',' expr
    { 
        $$ = concat($1, ", ", $3); 
    }
    ;   

statements
    : statement
    { 
        $$ = $1; 
    }
    | statements statement
    { 
        $$ = concat($1, "\n", $2); 
    }
    ;

statement
    : sentence ';'              
    { 
        $$ = concat($1, " ", ";\n");
    }
    | if_stmt
    { 
        $$ = $1; 
    }
    | while_stmt
    {
        $$ = $1; 
    }
    ;
    
sentence
    : decl_stmt         { $$ = $1; }
    | assign_stmt       { $$ = $1; }
    | return_stmt       { $$ = $1; }
    | call_stmt         { $$ = $1; }
    | %empty            { $$ = " "; }
    ;

decl_stmt
    : type_dec id_list  
    { 
        printf("DECL\t"); 
        $$ = concat(itoType($1), " ", $2); 
        printf("%s\n", $$);
    }
    ;

type_dec
    : INT               { $$ = 1; }
    | VOID              { $$ = 2; }
    ;

id_list
    : id_elem ',' id_list   
    { 
        $$ = concat($1, ",", $3); 
        printf("%s\n", $$); 
    }
    | id_elem               { $$ = $1; }
    ;

id_elem
    : IDENTIFIER            { $$ = $1; }
    | assign_stmt           { $$ = $1; }
    | call_stmt             { $$ = $1; }
    ;

assign_stmt
    : IDENTIFIER '=' expr  
    { 
        printf("ASSIGN\t"); 
        $$ = concat($1, "=", $3); 
        printf("%s\n", $$); 
    }
    ;

expr
    : expr '=' expr         
    { 
        printf("ASSIGN\t"); 
        $$ = concat($1, "=", $3); 
        printf("%s\n", $$); 
    }
    | expr OR expr         
    { 
        printf("OR\t"); 
        $$ = concat($1, "||", $3); 
        printf("%s\n", $$); 
    }
    | expr AND expr         
    { 
        printf("AND\t"); 
        $$ = concat($1, "&&", $3); 
        printf("%s\n", $$); 
    }
    | expr '|' expr         
    { 
        printf("BITWISE OR\t"); 
        $$ = concat($1, "|", $3); 
        printf("%s\n", $$); 
    }
    | expr '^' expr         
    { 
        printf("BITWISE XOR\t"); 
        $$ = concat($1, "^", $3); 
        printf("%s\n", $$); 
    }
    | expr '&' expr         
    { 
        printf("BITWISE AND\t"); 
        $$ = concat($1, "&", $3); 
        printf("%s\n", $$); 
    }
    | expr EQ expr         
    { 
        printf("EQ\t"); 
        $$ = concat($1, "==", $3); 
        printf("%s\n", $$); 
    }
    | expr NE expr         
    { 
        printf("NE\t"); 
        $$ = concat($1, "!=", $3); 
        printf("%s\n", $$); 
    }
    | expr '<' expr         
    { 
        printf("LT\t"); 
        $$ = concat($1, "<", $3); 
        printf("%s\n", $$); 
    }
    | expr '>' expr         
    { 
        printf("GT\t"); 
        $$ = concat($1, ">", $3); 
        printf("%s\n", $$); 
    }
    | expr LE expr         
    { 
        printf("LE\t"); 
        $$ = concat($1, "<=", $3); 
        printf("%s\n", $$); 
    }
    | expr GE expr         
    { 
        printf("GE\t"); 
        $$ = concat($1, ">=", $3); 
        printf("%s\n", $$); 
    }
    | expr '+' expr         
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
    | '!' expr %prec '!'    
    { 
        printf("NOT\t"); 
        $$ = concat("!", $2, ""); 
        printf("%s\n", $$); 
    }
    | '~' expr %prec '~'    
    { 
        printf("BITWISE NOT\t"); 
        $$ = concat("~", $2, ""); 
        printf("%s\n", $$); 
    }
    | factor                { $$ = $1;}
    ;

factor
    : INT_NUMBER        
    { 
        printf("INTEGER \t%s\n", $1);
    }
    | IDENTIFIER          
    { 
        printf("IDENTIFIER\t%s\n", $1);
    }
    | call_stmt
    { 
        $$ = $1; 
        printf("%s\n", $$);
    }
    ;

return_stmt
    : RETURN expr       
    { 
        printf("RETURN\t"); 
        $$ = concat("return", " ", $2); 
        printf("%s\n", $$); 
    }
    ;

call_stmt
    : IDENTIFIER '(' argument ')'
    {
        printf("CALL\t");
        char* func_name = $1;
        char* func_args = concat("(", $3, ")"); 
        $$ = concat(func_name, func_args, "");
        printf("%s\n", $$);
    }
    ;

if_stmt
    : IF '(' expr ')' '{' statements '}'
    {
        printf("IF\t");
        char* if_cond = concat("(", $3, ")");
        char* if_body = concat("{\n", $6, "}");
        $$ = concat("if ", if_cond, if_body);
        printf("%s\n", $$);
    }
    | IF '(' expr ')' '{' statements '}' ELSE '{' statements '}'
    {
        printf("IF ELSE\t");
        char* if_cond = concat("if (", $3, ")");
        char* if_body = concat("{\n", $6, "}");
        char* else_body = concat("else {\n", $10, "}");
        $$ = concat(if_cond, if_body, else_body);
        printf("%s\n", $$);
    }
    ;

while_stmt
    : WHILE '(' expr ')' '{' statements '}'
    {
        printf("WHILE\t");
        char* while_cond = concat("(", $3, ")");
        char* while_body = concat("{\n", $6, "}");
        $$ = concat("while", while_cond, while_body);
        printf("%s\n", $$);
    }
    ;

%%

