#pragma once

#include <stdlib.h> /* malloc, realloc. */
#include <string.h> /* strlen. */

struct labelrec
{
  char* label;   /* name of label */
  struct labelrec *next;  /* link field */
};

typedef struct labelrec labelrec;

// label stack

extern labelrec *label_stack;

void pushLabel (char const *label);
char* popLabel (void);
char* topLabel (void);