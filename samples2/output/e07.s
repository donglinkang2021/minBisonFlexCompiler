.intel_syntax noprefix
.global main
.global add10
.extern printf
.data
format_str:
.asciz "%d\n"
.text

add10:
push ebp
mov ebp, esp
sub esp, 0xc
mov eax, 10
mov DWORD PTR [ebp-4], eax

mov eax, DWORD PTR [ebp+8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
add eax, ebx
mov DWORD PTR [ebp-4], eax

mov eax, DWORD PTR [ebp-4]
leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0xc

mov eax, 1
push eax
call add10
add esp, 0x4
mov DWORD PTR [ebp-4], eax

mov eax, 0
leave
ret

