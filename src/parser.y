%{
    #include <stdio.h>
    #include "utils.h"
    #include "symbol.h"
    varrec *var_table;
    int var_count = 0, is_begin_decl = 0;
    extern int yylex(void);
%}

%code requires {
#include "code.h"
}

// Terminals


%debug

%locations

%union {
    int intval;
    code* codeval;
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
%token <codeval>     IDENTIFIER
%token <codeval>     INT_NUMBER

%type <codeval> program
%type <codeval> function
%type <codeval> parameter
%type <codeval> argument

%type <codeval> statements
%type <codeval> statement
%type <codeval> sentence 

%type <codeval> decl_stmt
%type <intval> type_dec
%type <codeval> id_list
%type <codeval> id_elem

%type <codeval> return_stmt 
%type <codeval> assign_stmt
%type <codeval> call_stmt
%type <codeval> expr 
%type <codeval> factor 

%type <codeval> if_stmt
%type <codeval> while_stmt

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
        printf("%s\n", $1->origin); 
        showAllVar();
        freeAllVar();
    }
    | program function
    { 
        printf("function\n");
        printf("%s\n", $2->origin); 
        showAllVar();
        freeAllVar();
    }
    ;

function
    : type_dec IDENTIFIER '(' parameter ')' '{' statements '}' 
    { 
        char* func_def = concat(itoType($1), " ", $2->origin);
        char* func_params = concat("(", $4->origin, ")");
        char* func_body = concat("{\n", $7->origin, "\n}");
        $$ = new_code(concat(func_def, func_params, func_body));
        is_begin_decl = 0;
    }
    ;

parameter
    : %empty
    { 
        $$ = new_code(" "); 
    }
    | type_dec IDENTIFIER
    { 
        $$ = new_code(concat(itoType($1), " ", $2->origin)); 
        is_begin_decl = 0;
    }
    | parameter ',' type_dec IDENTIFIER
    { 
        char* para1 = $1->origin;
        char* para2 = concat(itoType($3), " ", $4->origin);
        $$ = new_code(concat(para1, ", ", para2)); 
        is_begin_decl = 0;
    }
    ;

argument
    : %empty
    { 
        $$ = new_code(" "); 
    }
    | expr
    { 
        $$ = $1; 
    }
    | argument ',' expr
    { 
        $$ = new_code(concat($1->origin, ", ", $3->origin)); 
    }
    ;   

statements
    : statement
    { 
        $$ = $1; 
    }
    | statements statement
    { 
        $$ = new_code(concat($1->origin, "\n", $2->origin)); 
    }
    ;

statement
    : sentence ';'              
    { 
        $$ = new_code(concat($1->origin, " ", ";"));
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
    | %empty            { $$ = new_code(" "); }
    | BREAK             { $$ = new_code("break");}
    | CONTINUE          { $$ = new_code("continue");} 
    ;

decl_stmt
    : type_dec id_list  
    { 
        $$ = new_code(concat(itoType($1), " ", $2->origin)); 
        is_begin_decl = 0;
    }
    ;

type_dec
    : INT
    { 
        $$ = 1; 
        is_begin_decl = 1;
    }
    | VOID
    { 
        $$ = 2;
        is_begin_decl = 1;
    }
    ;

id_list
    : id_elem ',' id_list   
    { 
        $$ = new_code(concat($1->origin, ",", $3->origin)); 
    }
    | id_elem               { $$ = $1; }
    ;

id_elem
    : IDENTIFIER
    { 
        $$ = $1;
        if (is_begin_decl){
            varrec* new_var = putVar($1->origin);
        }
    }
    | assign_stmt           { $$ = $1; }
    ;

assign_stmt
    : IDENTIFIER '=' expr  
    { 
        $$ = new_code(concat($1->origin, "=", $3->origin)); 
        if (is_begin_decl){
            varrec* new_var = putVar($1->origin);
        }
    }
    ;

expr
    : expr '=' expr         
    { 
        $$ = new_code(concat($1->origin, "=", $3->origin));
    }
    | expr OR expr         
    { 
        $$ = new_code(concat($1->origin, "||", $3->origin));
    }
    | expr AND expr         
    { 
        $$ = new_code(concat($1->origin, "&&", $3->origin));
    }
    | expr '|' expr         
    { 
        $$ = new_code(concat($1->origin, "|", $3->origin));
    }
    | expr '^' expr         
    { 
        $$ = new_code(concat($1->origin, "^", $3->origin));
    }
    | expr '&' expr         
    { 
        $$ = new_code(concat($1->origin, "&", $3->origin));
    }
    | expr EQ expr         
    { 
        $$ = new_code(concat($1->origin, "==", $3->origin));
    }
    | expr NE expr         
    { 
        $$ = new_code(concat($1->origin, "!=", $3->origin));
    }
    | expr '<' expr         
    { 
        $$ = new_code(concat($1->origin, "<", $3->origin));
    }
    | expr '>' expr         
    { 
        $$ = new_code(concat($1->origin, ">", $3->origin));
    }
    | expr LE expr         
    { 
        $$ = new_code(concat($1->origin, "<=", $3->origin));
    }
    | expr GE expr         
    { 
        $$ = new_code(concat($1->origin, ">=", $3->origin));
    }
    | expr '+' expr         
    { 
        $$ = new_code(concat($1->origin, "+", $3->origin));
    }
    | expr '-' expr         
    { 
        $$ = new_code(concat($1->origin, "-", $3->origin));
    }
    | expr '*' expr         
    { 
        $$ = new_code(concat($1->origin, "*", $3->origin));
    }
    | expr '/' expr         
    { 
        $$ = new_code(concat($1->origin, "/", $3->origin));
    }
    | expr '%' expr         
    { 
        $$ = new_code(concat($1->origin, "%", $3->origin));
    }
    | '(' expr ')'          
    { 
        $$ = new_code(concat("(", $2->origin, ")"));
    }
    | '-' expr %prec NEG    
    { 
        $$ = new_code(concat("-", $2->origin, ""));
    }
    | '+' expr %prec POS    
    { 
        $$ = new_code(concat("+", $2->origin, ""));
    }
    | '!' expr %prec '!'    
    { 
        $$ = new_code(concat("!", $2->origin, ""));
    }
    | '~' expr %prec '~'    
    { 
        $$ = new_code(concat("~", $2->origin, ""));
    }
    | factor                { $$ = $1;}
    ;

factor
    : INT_NUMBER        
    {
        $$ = $1;
    }
    | IDENTIFIER          
    {
        $$ = $1;
    }
    | call_stmt
    { 
        $$ = $1; 
    }
    ;

return_stmt
    : RETURN expr       
    { 
        $$ = new_code(concat("return", " ", $2->origin));
    }
    ;

call_stmt
    : IDENTIFIER '(' argument ')'
    {
        char* func_name = $1->origin;
        char* func_args = concat("(", $3->origin, ")"); 
        $$ = new_code(concat(func_name, func_args, ""));
    }
    ;

if_stmt
    : IF '(' expr ')' '{' statements '}'
    {
        char* if_cond = concat("(", $3->origin, ")");
        char* if_body = concat("\n{\n", $6->origin, "\n}\n");
        $$ = new_code(concat("if ", if_cond, if_body));
    }
    | IF '(' expr ')' '{' statements '}' ELSE '{' statements '}'
    {
        char* if_cond = concat("if (", $3->origin, ")");
        char* if_body = concat("\n{\n", $6->origin, "\n}\n");
        char* else_body = concat("else \n{\n", $10->origin, "\n}\n");
        $$ = new_code(concat(if_cond, if_body, else_body));
    }
    ;

while_stmt
    : WHILE '(' expr ')' '{' statements '}'
    {
        char* while_cond = concat("(", $3->origin, ")");
        char* while_body = concat("\n{\n", $6->origin, "\n}\n");
        $$ = new_code(concat("while", while_cond, while_body));
    }
    ;

%%

