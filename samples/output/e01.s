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
sub esp, 0x10
mov eax, 5
mov DWORD PTR [ebp-4], eax
mov eax, 3
mov DWORD PTR [ebp-8], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setle al
movzx eax, al
cmp eax, 0
je .L_if_tail_0x0
mov eax, DWORD PTR [ebp-4]
push eax
push offset format_str
call printf
add esp, 8
.L_if_tail_0x0:


mov eax, DWORD PTR [ebp-8]
push eax
push offset format_str
call printf
add esp, 8

mov eax, 0
leave
ret

