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
mov eax, 0
mov DWORD PTR [ebp-4], eax

.L_while_head_0x0:
mov eax, 3
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setl al
movzx eax, al
cmp eax, 0
je .L_while_tail_0x0
mov eax, 0
mov DWORD PTR [ebp-8], eax

.L_while_head_0x1:
mov eax, 2
push eax
mov eax, DWORD PTR [ebp-8]
pop ebx
cmp eax, ebx
setl al
movzx eax, al
cmp eax, 0
je .L_while_tail_0x1
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, 10
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
imul eax, ebx
pop ebx
add eax, ebx
push eax
push offset format_str
call printf
add esp, 8

mov eax, 1
push eax
mov eax, DWORD PTR [ebp-8]
pop ebx
add eax, ebx
mov DWORD PTR [ebp-8], eax
jmp .L_while_head_0x1
.L_while_tail_0x1:


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

