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
sub esp, 0xc
mov eax, 0
mov DWORD PTR [ebp-4], eax

.L_while_head_0x0:
mov eax, 11
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setl al
movzx eax, al
cmp eax, 0
je .L_while_tail_0x0
mov eax, 1
push eax
mov eax, 3
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cdq
idiv ebx
mov eax, edx
pop ebx
cmp eax, ebx
sete al
movzx eax, al
cmp eax, 0
je .L_if_tail_0x0
mov eax, 2
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
add eax, ebx
mov DWORD PTR [ebp-4], eax

mov eax, DWORD PTR [ebp-4]
push eax
push offset format_str
call printf
add esp, 8

jmp .L_while_head_0x0
.L_if_tail_0x0:


mov eax, 0
push eax
mov eax, 2
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cdq
idiv ebx
mov eax, edx
pop ebx
cmp eax, ebx
sete al
movzx eax, al
cmp eax, 0
je .L_if_tail_0x1
mov eax, DWORD PTR [ebp-4]
push eax
push offset format_str
call printf
add esp, 8
.L_if_tail_0x1:


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

