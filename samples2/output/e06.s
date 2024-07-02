.intel_syntax noprefix
.global main
.global myprint
.extern printf
.data
format_str:
.asciz "%d\n"
.text

myprint:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, DWORD PTR [ebp+8]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp+12]
push eax
push offset format_str
call printf
add esp, 8

mov eax, DWORD PTR [ebp+16]
push eax
push offset format_str
call printf
add esp, 8
leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0x14
mov eax, 1
mov DWORD PTR [ebp-4], eax
mov eax, 2
mov DWORD PTR [ebp-8], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
add eax, ebx
mov DWORD PTR [ebp-12], eax

mov eax, DWORD PTR [ebp-12]
push eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call myprint
add esp, 0xc

mov eax, 0
leave
ret

