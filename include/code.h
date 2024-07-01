#pragma once

#include <stdlib.h> /* malloc, realloc. */
#include <string.h> /* strlen. */

struct code
{
    char* description;
    char* assembly;
};

typedef struct code code;

code* new_code(char* desp);