#include "utils.h"

void yyerror(char *s, ...)
{
    extern int yylineno;
    va_list ap;
    va_start(ap, s);
    fprintf(stderr, "%d: error: ", yylineno);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
}

char* concat(const char* a, const char* b, const char* c) {
    char* temp = malloc(strlen(a) + strlen(b) + strlen(c) + 4);
    sprintf(temp, "%s%s%s", a, b, c);
    return temp;
}