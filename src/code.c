#include "code.h"

code* new_code(char* desp){
    code* res = (code*) malloc(sizeof(code));
    res->description = strdup(desp);
    res->assembly = "";
    return res;
}