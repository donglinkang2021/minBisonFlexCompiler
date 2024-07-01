#pragma once

#include <assert.h>
#include <stdlib.h> /* malloc, realloc. */
#include <string.h> /* strlen. */

struct varrec
{
  char *name;   /* name of local var */
  int index;    /* index of local var, DWORD PTR [ebp-4*index]*/
  struct varrec *next;  /* link field */
};

typedef struct varrec varrec;

extern varrec *var_table;

varrec *putvar (char const *name, int index);
varrec *getvar (char const *name);
