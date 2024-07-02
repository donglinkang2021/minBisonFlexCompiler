.intel_syntax noprefix
.global main
.global opplus_114514
.global opxor
.global opor
.global opand
.global opmod
.global opdiv
.global opmul
.global opminus
.global opplus
.extern printf
.data
format_str:
.asciz "%d\n"
.text

opplus:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
add eax, ebx
leave
ret

opminus:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
sub eax, ebx
leave
ret

opmul:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
imul eax, ebx
leave
ret

opdiv:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
cdq
idiv ebx
leave
ret

opmod:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
cdq
idiv ebx
mov eax, edx
leave
ret

opand:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
and eax, ebx
leave
ret

opor:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
or eax, ebx
leave
ret

opxor:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
xor eax, ebx
leave
ret

opplus_114514:
push ebp
mov ebp, esp
sub esp, 0x14
mov eax, DWORD PTR [ebp+8]
mov DWORD PTR [ebp-4], eax
mov eax, DWORD PTR [ebp+16]
mov DWORD PTR [ebp-8], eax
mov eax, DWORD PTR [ebp+20]
mov DWORD PTR [ebp-12], eax

mov eax, 114514
push eax
mov eax, DWORD PTR [ebp+12]
pop ebx
add eax, ebx
leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0x34

mov eax, 114
mov DWORD PTR [ebp-4], eax

mov eax, 514
mov DWORD PTR [ebp-8], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opplus
add esp, 0x8
mov DWORD PTR [ebp-20], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opminus
add esp, 0x8
mov DWORD PTR [ebp-12], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opmul
add esp, 0x8
mov DWORD PTR [ebp-16], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opdiv
add esp, 0x8
mov DWORD PTR [ebp-24], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opmod
add esp, 0x8
mov DWORD PTR [ebp-28], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opand
add esp, 0x8
mov DWORD PTR [ebp-32], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opor
add esp, 0x8
mov DWORD PTR [ebp-36], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call opxor
add esp, 0x8
mov DWORD PTR [ebp-40], eax


mov eax, 4
push eax
mov eax, 3
push eax
mov eax, 2
push eax
mov eax, 1
push eax
call opplus_114514
add esp, 0x10
mov DWORD PTR [ebp-44], eax

mov eax, DWORD PTR [ebp-4]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-8]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-20]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-12]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-16]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-24]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-28]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-32]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-36]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-40]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp-44]
push eax
push offset format_str
call printf
add esp, 8

mov eax, 0
leave
ret

