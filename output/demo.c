//  char *temp = malloc(strlen($1) + strlen($3) + 4); sprintf(temp, "%s + %s", $1, $3); $$ = temp;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* concat(const char* a, const char* b, const char* op) {
    char* temp = malloc(strlen(a) + strlen(b) + strlen(op) + 4);
    sprintf(temp, "%s %s %s", a, op, b);
    return temp;
}

int demo(int a, int b) {
    int c = 2;
    return a + b;
}

char* itoHex(int num) {
    char* temp = malloc(10);
    sprintf(temp, "0x%x", num);
    return temp;
}

int main(int argc, const char *args[])
{
    char* c = concat("1", "2", "+");
    printf("%s\n", c);
    printf("%s\n", itoHex(255 + 1));
    return 0;
}

// gcc -o demo demo.c && ./demo