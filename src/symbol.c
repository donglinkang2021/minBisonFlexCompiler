#include "symbol.h"

varrec* putVar (char const *name){
  varrec *res = (varrec *) malloc (sizeof (varrec));
  res->name = strdup (name);
  res->index = var_count;
  res->next = var_table;
  var_table = res;
  var_count++;
  return res;
}

varrec* getVar (char const *name){
  for (varrec *p = var_table; p; p = p->next)
    if (strcmp (p->name, name) == 0)
      return p;
  return NULL;
}

const char* getVarAddr (char const *name){
  varrec *p = getVar (name);
  if (p == NULL)
    return NULL;
  char *res = (char *) malloc (strlen (p->name) + 30);
  sprintf (res, "DWORD PTR [ebp-%d]", (p->index + 1) * 4);
  return res;
}

void showAllVar (void){
  for (varrec *p = var_table; p; p = p->next)
    printf ("%10s\t%s\n", p->name, getVarAddr(p->name));
}

void freeAllVar (void){
  for (varrec *p = var_table; p; p = p->next){
    free (p->name);
    free (p);
  }
  var_table = NULL;
  var_count = 0;
}