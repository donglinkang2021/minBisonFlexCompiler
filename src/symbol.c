#include "symbol.h"

varrec* putvar (char const *name, int index){
  varrec *res = (varrec *) malloc (sizeof (varrec));
  res->name = strdup (name);
  res->index = index;
  res->next = var_table;
  var_table = res;
  return res;
}

varrec* getvar (char const *name){
  for (varrec *p = var_table; p; p = p->next)
    if (strcmp (p->name, name) == 0)
      return p;
  return NULL;
}