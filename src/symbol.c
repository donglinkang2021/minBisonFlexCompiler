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
  printf ("Local variable table:\n");
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

varrec* putArg (char const *name){
  varrec *res = (varrec *) malloc (sizeof (varrec));
  res->name = strdup (name);
  res->index = arg_count;
  res->next = arg_table;
  arg_table = res;
  arg_count++;
  return res;
}

varrec* getArg (char const *name){
  for (varrec *p = arg_table; p; p = p->next)
    if (strcmp (p->name, name) == 0)
      return p;
  return NULL;
}

const char* getArgAddr (char const *name){
  varrec *p = getArg (name);
  if (p == NULL)
    return NULL;
  char *res = (char *) malloc (strlen (p->name) + 30);
  sprintf (res, "DWORD PTR [ebp+%d]", (p->index + 2) * 4);
  return res;
}

void showAllArg (void){
  printf ("Argument table:\n");
  for (varrec *p = arg_table; p; p = p->next)
    printf ("%10s\t%s\n", p->name, getArgAddr(p->name));
}

void freeAllArg (void){
  for (varrec *p = arg_table; p; p = p->next){
    free (p->name);
    free (p);
  }
  arg_table = NULL;
  arg_count = 0;
}

const char* getVarOrArgAddr (char const *name){
  const char *res = getVarAddr (name);
  if (res == NULL)
    res = getArgAddr (name);
  return res;
}

funcrec* putFunc (char const *name, int arg_count, int var_count){
  funcrec *res = (funcrec *) malloc (sizeof (funcrec));
  res->name = strdup (name);
  res->arg_count = arg_count;
  res->var_count = var_count;
  res->next = func_table;
  func_table = res;
  return res;
}

funcrec* getFunc (char const *name){
  for (funcrec *p = func_table; p; p = p->next)
    if (strcmp (p->name, name) == 0)
      return p;
  return NULL;
}

void showAllFunc (void){
  printf ("Function table:\n");
  for (funcrec *p = func_table; p; p = p->next)
    printf ("%10s\t%d\t%d\n", p->name, p->arg_count, p->var_count);
}

char* getAllFunc(void){
  char *res = (char *) malloc (1);
  res[0] = '\0';
  for (funcrec *p = func_table; p; p = p->next){
    char *new_res = (char *) malloc (strlen (res) + strlen (p->name) + 30);
    sprintf (new_res, "%s.global %s\n", res, p->name);
    free (res);
    res = new_res;
  }
  return res;
}

void freeAllFunc (void){
  for (funcrec *p = func_table; p; p = p->next){
    free (p->name);
    free (p);
  }
  func_table = NULL;
}