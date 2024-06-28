#include <stdio.h>

#include "lexer.h"
#include "parser.h"

int main(int argc, const char *args[])
{
	/* 将注释去掉就能看到stack具体是怎么工作的.. */
    /* yydebug = 1; */

	extern FILE *yyin;
	if(argc > 1 && (yyin = fopen(args[1], "r")) == NULL) {
		fprintf(stderr, "can not open %s\n", args[1]);
		exit(1);
	}
	if(yyparse()) {
		exit(-1);
	}
	
    return 0;
}