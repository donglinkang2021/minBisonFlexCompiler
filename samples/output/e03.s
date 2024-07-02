.intel_syntax noprefix
.global main
.global sum
.extern printf
.data
format_str:
.asciz "%d\n"
.text

sum:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, 0
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
cmp eax, ebx
sete al
movzx eax, al
cmp eax, 0
je .L_else_head_0x0
mov eax, 0
jmp .L_if_tail_0x0
.L_else_head_0x0:
mov eax, 1
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
sub eax, ebx
push eax
call sum
add esp, 0x4
push eax
mov eax, DWORD PTR [ebp+8]
pop ebx
add eax, ebx
.L_if_tail_0x0:

leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0x8
mov eax, 5
push eax
call sum
add esp, 0x4
push eax
push offset format_str
call printf
add esp, 8

mov eax, 0
leave
ret

