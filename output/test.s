.intel_syntax noprefix
.global main
.extern printf
.data
format_str:
.asciz "%d\n"
.text

main:
push ebp
mov ebp, esp
sub esp, 0x100



mov eax, 1
mov DWORD PTR [ebp-4], eax

mov eax, DWORD PTR [ebp-4]
push eax
push offset format_str
call printf
add esp, 8

mov eax, 12
mov DWORD PTR [ebp-8], eax

mov eax, DWORD PTR [ebp-8]
push eax
push offset format_str
call printf
add esp, 8

mov eax, 10
push eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
add eax, ebx
pop ebx
cdq
idiv ebx
mov eax, edx
push eax
mov eax, 114514
pop ebx
add eax, ebx
mov DWORD PTR [ebp-12], eax

mov eax, DWORD PTR [ebp-12]
push eax
push offset format_str
call printf
add esp, 8

mov eax, 0
leave
ret

