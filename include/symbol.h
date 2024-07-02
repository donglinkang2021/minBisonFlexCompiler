#pragma once

#include <stdio.h>
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

// local variable table
extern varrec *var_table;
extern int var_count;
extern int is_begin_decl;

varrec *putVar (char const *name);
varrec *getVar (char const *name);
const char* getVarAddr (char const *name);
void showAllVar (void);
void freeAllVar (void);

// argument table
extern varrec *arg_table;
extern int arg_count;

varrec *putArg (char const *name);
varrec *getArg (char const *name);
const char* getArgAddr (char const *name);
void showAllArg (void);
void freeAllArg (void);

// get the index of the variable
const char* getVarOrArgAddr (char const *name);
