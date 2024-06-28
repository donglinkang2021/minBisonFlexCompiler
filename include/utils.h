#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void yyerror(char *s, ...);

char* concat(const char* a, const char* b, const char* c);

char* itoType(int type);
