.intel_syntax noprefix
.global main
.global test
.extern printf
.data
format_str:
.asciz "%d\n"
.text

test:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+8]
push eax
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
push eax
mov eax, DWORD PTR [ebp+12]
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
add eax, ebx
pop ebx
imul eax, ebx
pop ebx
cdq
idiv ebx
pop ebx
and eax, ebx
leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0x10
mov eax, 114
mov DWORD PTR [ebp-4], eax
mov eax, 514
mov DWORD PTR [ebp-8], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
add eax, ebx
push eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
imul eax, ebx
push eax
call test
add esp, 0x8
push eax
mov eax, 1
pop ebx
add eax, ebx
push eax
push offset format_str
call printf
add esp, 8

mov eax, 0
leave
ret

