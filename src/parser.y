%{
    #include <stdio.h>
    #include "utils.h"
    #include "symbol.h"
    #include "label.h"
    varrec *var_table;
    int var_count = 0, is_begin_decl = 0;
    varrec *arg_table;
    int arg_count = 0;
    funcrec *func_table;
    int if_count = 0, while_count = 0;
    labelrec *label_stack;
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
%type <codeval> func_decl
%type <codeval> func_body
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

// if statement and label
%type <codeval> if_stmt
%type <codeval> label_if_tail
%type <codeval> label_else_head

// while statement and label
%type <codeval> while_stmt
%type <codeval> label_while_head
%type <codeval> label_while_tail

%type <codeval> begin

%start begin

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

begin
    : program
    { 
        char* begin_label = ".intel_syntax noprefix\n"
                            ".global main\n"
                            ".extern printf\n"
                            ".data\n"
                            "format_str:\n"
                            ".asciz \"%d\\n\"\n"
                            ".text\n";
        char* asm_code = concat(begin_label, "\r\n", $1->assembly);
        // printf("Assembly code:\n%s\n", asm_code); 
        printf("%s\n", asm_code); 
    }
    ;

program
    : function
    {   
        // printf("%s\n", $1->origin); 
        // printf("----------------------------------------\n");
        // showAllVar();
        // showAllArg();
        // printf("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n");
        freeAllVar();
        freeAllArg();
        $$ = new_code($1->origin);
        $$->assembly = $1->assembly;
    }
    | program function
    { 
        // printf("%s\n", $2->origin); 
        // printf("----------------------------------------\n");
        // showAllVar();
        // showAllArg();
        // printf("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n");
        freeAllVar();
        freeAllArg();
        $$ = new_code(concat($1->origin, "\n", $2->origin));
        $$->assembly = concat($1->assembly, "\n", $2->assembly);
    }
    ;

function
    :  func_decl func_body
    { 
        $$ = new_code(concat($1->origin, $2->origin, ""));
        
        char* func_label = concat(func_table->name, ":", "\n");
        char* func_prologue = "push ebp\nmov ebp, esp\n";
        char* sub_esp;
        if (strcmp($2->origin, "main") == 0){
            sub_esp = "sub esp, 0x100\n";
        } else {
            sub_esp = concat("sub esp, ", itoHex(var_count * 4 + 8), "\n");
        }
        func_prologue = concat(func_label, func_prologue, sub_esp);
        char* func_epilogue = "leave\nret\n";
        char* func_asm = concat(func_prologue, $2->assembly, func_epilogue);
        $$->assembly = func_asm;
    }
    ;

func_decl
    : type_dec IDENTIFIER '(' parameter ')'
    { 
        is_begin_decl = 0;
        char* func_def = concat(itoType($1), " ", $2->origin);
        char* func_params = concat("(", $4->origin, ")");
        $$ = new_code(concat(func_def, func_params, ""));
        putFunc($2->origin, arg_count, var_count);
    }
    ;

func_body
    : '{' statements '}'
    { 
        $$ = new_code(concat("{\n", $2->origin, "\n}"));
        $$->assembly = $2->assembly;
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
        putArg($2->origin);
        is_begin_decl = 0;
    }
    | parameter ',' type_dec IDENTIFIER
    { 
        char* para1 = $1->origin;
        char* para2 = concat(itoType($3), " ", $4->origin);
        $$ = new_code(concat(para1, ", ", para2)); 
        putArg($4->origin);
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
        $$->assembly = concat($1->assembly, "push eax", "\n");
    }
    | argument ',' expr
    { 
        $$ = new_code(concat($1->origin, ", ", $3->origin)); 
        $$->assembly = concat($3->assembly, "push eax\n", $1->assembly);
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
        // note: remove "\n" if you don't want to 
        // separate each statement with a newline
        $$->assembly = concat($1->assembly, "\n", $2->assembly); 
    }
    ;

statement
    : sentence ';'              
    { 
        $$ = new_code(concat($1->origin, " ", ";"));
        $$->assembly = $1->assembly;
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
    | BREAK             
    { 
        $$ = new_code("break");
        char* count = label_stack->label;
        char* label = concat(".L_while_tail", "_", count);
        $$->assembly = concat("jmp ", label, "\n");
    }
    | CONTINUE          
    { 
        $$ = new_code("continue");
        char* count = label_stack->label;
        char* label = concat(".L_while_head", "_", count);
        $$->assembly = concat("jmp ", label, "\n");
    } 
    ;

decl_stmt
    : type_dec id_list  
    { 
        $$ = new_code(concat(itoType($1), " ", $2->origin)); 
        $$->assembly = $2->assembly;
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
        $$->assembly = concat($1->assembly, "", $3->assembly);
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
        char* expr_asm = $3->assembly;
        char* assign_asm = concat("mov ", getVarOrArgAddr($1->origin), ", eax\n");
        $$->assembly = concat(expr_asm, "", assign_asm);
    }
    ;

expr
    : expr OR expr         
    { 
        $$ = new_code(concat($1->origin, "||", $3->origin));
        
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* logical_or_asm =  "test eax, eax\n"
                                "setne al\n"
                                "test ebx, ebx\n"
                                "setne bl\n"
                                "or al, bl\n"
                                "movzx eax, al\n";

        $$->assembly = concat(expr2, expr1, logical_or_asm);

    }
    | expr AND expr         
    { 
        $$ = new_code(concat($1->origin, "&&", $3->origin));

        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* logical_or_asm =  "test eax, eax\n"
                                "setne al\n"
                                "test ebx, ebx\n"
                                "setne bl\n"
                                "and al, bl\n"
                                "movzx eax, al\n";

        $$->assembly = concat(expr2, expr1, logical_or_asm);
    }
    | expr '|' expr         
    { 
        $$ = new_code(concat($1->origin, "|", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* or_asm = concat(expr2, expr1, "or eax, ebx\n");

        $$->assembly = or_asm;
    }
    | expr '^' expr         
    { 
        $$ = new_code(concat($1->origin, "^", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* xor_asm = concat(expr2, expr1, "xor eax, ebx\n");

        $$->assembly = xor_asm;
    }
    | expr '&' expr         
    { 
        $$ = new_code(concat($1->origin, "&", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* and_asm = concat(expr2, expr1, "and eax, ebx\n");

        $$->assembly = and_asm;
    }
    | expr EQ expr         
    { 
        $$ = new_code(concat($1->origin, "==", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* eq_asm = concat(expr2, expr1, "cmp eax, ebx\nsete al\nmovzx eax, al\n");

        $$->assembly = eq_asm;
    }
    | expr NE expr         
    { 
        $$ = new_code(concat($1->origin, "!=", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* ne_asm = concat(expr2, expr1, "cmp eax, ebx\nsetne al\nmovzx eax, al\n");

        $$->assembly = ne_asm;
    }
    | expr '<' expr         
    { 
        $$ = new_code(concat($1->origin, "<", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* lt_asm = concat(expr2, expr1, "cmp eax, ebx\nsetl al\nmovzx eax, al\n");

        $$->assembly = lt_asm;
    }
    | expr '>' expr         
    { 
        $$ = new_code(concat($1->origin, ">", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* gt_asm = concat(expr2, expr1, "cmp eax, ebx\nsetg al\nmovzx eax, al\n");

        $$->assembly = gt_asm;
    }
    | expr LE expr         
    { 
        $$ = new_code(concat($1->origin, "<=", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* le_asm = concat(expr2, expr1, "cmp eax, ebx\nsetle al\nmovzx eax, al\n");

        $$->assembly = le_asm;
    }
    | expr GE expr         
    { 
        $$ = new_code(concat($1->origin, ">=", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* ge_asm = concat(expr2, expr1, "cmp eax, ebx\nsetge al\nmovzx eax, al\n");

        $$->assembly = ge_asm;
    }
    | expr '+' expr         
    { 
        $$ = new_code(concat($1->origin, "+", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* add_asm = concat(expr2, expr1, "add eax, ebx\n");

        $$->assembly = add_asm;
    }
    | expr '-' expr         
    { 
        $$ = new_code(concat($1->origin, "-", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* sub_asm = concat(expr2, expr1, "sub eax, ebx\n");

        $$->assembly = sub_asm;
    }
    | expr '*' expr         
    { 
        $$ = new_code(concat($1->origin, "*", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* mul_asm = concat(expr2, expr1, "imul eax, ebx\n");

        $$->assembly = mul_asm;
    }
    | expr '/' expr         
    { 
        $$ = new_code(concat($1->origin, "/", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* div_asm = concat(expr2, expr1, "cdq\nidiv ebx\n");

        $$->assembly = div_asm;
    }
    | expr '%' expr         
    { 
        $$ = new_code(concat($1->origin, "%", $3->origin));
        char* expr1_asm = $1->assembly;
        char* expr2_asm = $3->assembly;

        char* expr2 = concat(expr2_asm, "push eax", "\n");
        char* expr1 = concat(expr1_asm, "pop ebx", "\n");
        char* mod_asm = concat(expr2, expr1, "cdq\nidiv ebx\nmov eax, edx\n");

        $$->assembly = mod_asm;
    }
    | '(' expr ')'          
    { 
        $$ = new_code(concat("(", $2->origin, ")"));
        $$->assembly = $2->assembly;
    }
    | '-' expr %prec NEG    
    { 
        $$ = new_code(concat("-", $2->origin, ""));
        $$->assembly = concat($2->assembly, "neg eax", "\n");
    }
    | '+' expr %prec POS    
    { 
        $$ = new_code(concat("+", $2->origin, ""));
        $$->assembly = $2->assembly;
    }
    | '!' expr %prec '!'    
    { 
        $$ = new_code(concat("!", $2->origin, ""));
        $$->assembly = concat($2->assembly, "test eax, eax\nsete al\nmovzx eax, al\n", "");
    }
    | '~' expr %prec '~'    
    { 
        $$ = new_code(concat("~", $2->origin, ""));
        $$->assembly = concat($2->assembly, "not eax", "\n");
    }
    | factor                
    { 
        $$ = $1;
    }
    ;

factor
    : INT_NUMBER        
    {
        $$ = $1;
        $$->assembly = concat("mov eax, ", $1->origin, "\n");
    }
    | IDENTIFIER          
    {
        $$ = $1;
        $$->assembly = concat("mov eax, ", getVarOrArgAddr($1->origin), "\n");
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
        $$->assembly = $2->assembly;
    }
    ;

call_stmt
    : IDENTIFIER '(' argument ')'
    {
        char* func_name = $1->origin;
        char* func_args = concat("(", $3->origin, ")"); 
        $$ = new_code(concat(func_name, func_args, ""));

        char *arg_asm, *call_asm, *add_esp;
        if (strcmp(func_name, "println_int") == 0){
            arg_asm = concat($3->assembly, "", "push offset format_str\n");
            call_asm = strdup("call printf\n");
            add_esp = strdup("add esp, 8\n");
        } else {
            arg_asm = $3->assembly;
            call_asm = concat("call ", func_name, "\n");
            int arg_count = getFunc(func_name)->arg_count;
            add_esp = concat("add esp, ", itoHex(arg_count * 4), "\n");
        }
        $$->assembly = concat(arg_asm, call_asm, add_esp);

    }
    ;

if_stmt
    : IF '(' expr ')' '{' statements '}' label_if_tail
    {
        char* if_cond = concat("(", $3->origin, ")");
        char* if_body = concat("\n{\n", $6->origin, "\n}\n");
        $$ = new_code(concat("if ", if_cond, if_body));
        // todo : add assembly code of if statement
        char* if_cond_asm = $3->assembly;
        char* jump_end = concat("cmp eax, 0\nje ", $8->origin, "\n");
        char* if_body_asm = $6->assembly;
        char* if_end_asm = $8->assembly;

        char* if_stmt_asm = concat(if_cond_asm, jump_end, if_body_asm);
        $$->assembly = concat(if_stmt_asm, if_end_asm, "\n");
        if_count++;
    }
    | IF '(' expr ')' '{' statements '}' ELSE '{' label_else_head statements '}' label_if_tail
    {
        char* if_cond = concat("if (", $3->origin, ")");
        char* if_body = concat("\n{\n", $6->origin, "\n}\n");
        char* else_body = concat("else \n{\n", $11->origin, "\n}\n");
        $$ = new_code(concat(if_cond, if_body, else_body));
        // todo : add assembly code of if-else statement
        char* if_cond_asm = $3->assembly;
        char* jump_else = concat("cmp eax, 0\nje ", $10->origin, "\n");
        char* if_body_asm = $6->assembly;
        char* jump_end = concat("jmp ", $13->origin, "\n");
        char* else_body_asm = concat($10->assembly, $11->assembly, "");
        char* if_end_asm = $13->assembly;

        char* if_stmt_asm = concat(if_cond_asm, jump_else, if_body_asm);
        char* else_stmt_asm = concat(jump_end, else_body_asm, if_end_asm);
        $$->assembly = concat(if_stmt_asm, else_stmt_asm, "\n");
        if_count++;
    }
    ;

label_if_tail
    : %empty
    {
        char* label = concat(".L_if_tail", "_", itoHex(if_count));
        $$ = new_code(label);
        $$->assembly = concat(label, ":", "\n");
    }
    ;

label_else_head
    : %empty
    {
        char* label = concat(".L_else_head", "_", itoHex(if_count));
        $$ = new_code(label);
        $$->assembly = concat(label, ":", "\n");
    }
    ;

while_stmt
    : WHILE '(' label_while_head expr ')' '{' statements '}' label_while_tail
    {
        char* while_cond = concat("(", $4->origin, ")");
        char* while_body = concat("\n{\n", $7->origin, "\n}\n");
        $$ = new_code(concat("while", while_cond, while_body));
        // todo : add assembly code of while statement
        char* while_head_asm = $3->assembly;
        char* while_cond_asm = $4->assembly;
        char* jump_end = concat("cmp eax, 0\nje ", $9->origin, "\n");
        char* while_body_asm = $7->assembly;
        char* jump_head = concat("jmp ", $3->origin, "\n");
        char* while_end_asm = $9->assembly;

        char* while_stmt_asm = concat(while_head_asm, while_cond_asm, jump_end);
        char* while_body_stmt_asm = concat(while_body_asm, jump_head, while_end_asm);
        $$->assembly = concat(while_stmt_asm, while_body_stmt_asm, "\n");
    }
    ;

label_while_head
    : %empty
    {
        char* count = itoHex(while_count);
        char* label = concat(".L_while_head", "_", count);
        pushLabel(count);
        $$ = new_code(label);
        $$->assembly = concat(label, ":", "\n");
        while_count++;
    }
    ;

label_while_tail
    : %empty
    {   
        char* count = popLabel();
        char* label = concat(".L_while_tail", "_", count);
        $$ = new_code(label);
        $$->assembly = concat(label, ":", "\n");
    }
    ;

%%

