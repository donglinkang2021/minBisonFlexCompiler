#include "label.h"

void pushLabel (char const *label)
{
  labelrec *new_label = (labelrec *) malloc (sizeof (labelrec));
  new_label->label = strdup (label);
  new_label->next = label_stack;
  label_stack = new_label;
}

char* popLabel (void)
{
  if (label_stack == NULL)
    return NULL;
  labelrec *top = label_stack;
  label_stack = label_stack->next;
  char *label = top->label;
  free (top);
  return label;
}
