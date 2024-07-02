.intel_syntax noprefix
.global main
.global print4
.extern printf
.data
format_str:
.asciz "%d\n"
.text

print4:
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

mov eax, DWORD PTR [ebp+20]
push eax
push offset format_str
call printf
add esp, 8
leave
ret

main:
push ebp
mov ebp, esp
sub esp, 0x68
mov eax, 114
mov DWORD PTR [ebp-4], eax
mov eax, 514
mov DWORD PTR [ebp-8], eax

mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
sete al
movzx eax, al
mov DWORD PTR [ebp-12], eax
mov eax, DWORD PTR [ebp-4]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
sete al
movzx eax, al
mov DWORD PTR [ebp-16], eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setne al
movzx eax, al
mov DWORD PTR [ebp-20], eax
mov eax, DWORD PTR [ebp-4]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setne al
movzx eax, al
mov DWORD PTR [ebp-24], eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setl al
movzx eax, al
mov DWORD PTR [ebp-28], eax
mov eax, DWORD PTR [ebp-4]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setl al
movzx eax, al
mov DWORD PTR [ebp-32], eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setle al
movzx eax, al
mov DWORD PTR [ebp-36], eax
mov eax, DWORD PTR [ebp-4]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setle al
movzx eax, al
mov DWORD PTR [ebp-40], eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setg al
movzx eax, al
mov DWORD PTR [ebp-44], eax
mov eax, DWORD PTR [ebp-4]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setg al
movzx eax, al
mov DWORD PTR [ebp-48], eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setge al
movzx eax, al
mov DWORD PTR [ebp-52], eax
mov eax, DWORD PTR [ebp-4]
push eax
mov eax, DWORD PTR [ebp-4]
pop ebx
cmp eax, ebx
setge al
movzx eax, al
mov DWORD PTR [ebp-56], eax

mov eax, DWORD PTR [ebp-24]
push eax
mov eax, DWORD PTR [ebp-20]
push eax
mov eax, DWORD PTR [ebp-16]
push eax
mov eax, DWORD PTR [ebp-12]
push eax
call print4
add esp, 0x10

mov eax, DWORD PTR [ebp-40]
push eax
mov eax, DWORD PTR [ebp-36]
push eax
mov eax, DWORD PTR [ebp-32]
push eax
mov eax, DWORD PTR [ebp-28]
push eax
call print4
add esp, 0x10

mov eax, DWORD PTR [ebp-56]
push eax
mov eax, DWORD PTR [ebp-52]
push eax
mov eax, DWORD PTR [ebp-48]
push eax
mov eax, DWORD PTR [ebp-44]
push eax
call print4
add esp, 0x10

mov eax, 1
push eax
mov eax, 1
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
and al, bl
movzx eax, al
mov DWORD PTR [ebp-60], eax
mov eax, 0
push eax
mov eax, 1
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
and al, bl
movzx eax, al
mov DWORD PTR [ebp-64], eax
mov eax, 1
push eax
mov eax, 0
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
and al, bl
movzx eax, al
mov DWORD PTR [ebp-68], eax
mov eax, 0
push eax
mov eax, 0
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
and al, bl
movzx eax, al
mov DWORD PTR [ebp-72], eax

mov eax, 1
push eax
mov eax, 1
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
or al, bl
movzx eax, al
mov DWORD PTR [ebp-76], eax
mov eax, 0
push eax
mov eax, 1
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
or al, bl
movzx eax, al
mov DWORD PTR [ebp-80], eax
mov eax, 1
push eax
mov eax, 0
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
or al, bl
movzx eax, al
mov DWORD PTR [ebp-84], eax
mov eax, 0
push eax
mov eax, 0
pop ebx
test eax, eax
setne al
test ebx, ebx
setne bl
or al, bl
movzx eax, al
mov DWORD PTR [ebp-88], eax

mov eax, 1
test eax, eax
sete al
movzx eax, al
mov DWORD PTR [ebp-92], eax
mov eax, 0
test eax, eax
sete al
movzx eax, al
mov DWORD PTR [ebp-96], eax

mov eax, DWORD PTR [ebp-72]
push eax
mov eax, DWORD PTR [ebp-68]
push eax
mov eax, DWORD PTR [ebp-64]
push eax
mov eax, DWORD PTR [ebp-60]
push eax
call print4
add esp, 0x10

mov eax, DWORD PTR [ebp-88]
push eax
mov eax, DWORD PTR [ebp-84]
push eax
mov eax, DWORD PTR [ebp-80]
push eax
mov eax, DWORD PTR [ebp-76]
push eax
call print4
add esp, 0x10

mov eax, 0
push eax
mov eax, 0
push eax
mov eax, DWORD PTR [ebp-96]
push eax
mov eax, DWORD PTR [ebp-92]
push eax
call print4
add esp, 0x10

mov eax, 0
leave
ret

