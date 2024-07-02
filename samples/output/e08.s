.intel_syntax noprefix
.global main
.global factorial
.extern printf
.data
format_str:
.asciz "%d\n"
.text

factorial:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, 1
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
cmp eax, ebx
setle al
movzx eax, al
cmp eax, 0
je .L_else_head_0x0
mov eax, 1
jmp .L_if_tail_0x0
.L_else_head_0x0:
mov eax, 1
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
sub eax, ebx
push eax
call factorial
add esp, 0x4
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
imul eax, ebx
.L_if_tail_0x0:

leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0xc
mov eax, 1
mov DWORD PTR [ebp-4], eax

.L_while_head_0x0:
mov eax, 5
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setle al
movzx eax, al
cmp eax, 0
je .L_while_tail_0x0
mov eax, DWORD PTR [ebp-4]
push eax
call factorial
add esp, 0x4
push eax
push offset format_str
call printf
add esp, 8

mov eax, 1
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
add eax, ebx
mov DWORD PTR [ebp-4], eax
jmp .L_while_head_0x0
.L_while_tail_0x0:


mov eax, 0
leave
ret

