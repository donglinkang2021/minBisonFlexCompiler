.intel_syntax noprefix
.global main
.global print4
.global print3
.extern printf
.data
format_str:
.asciz "%d\n"
.text

print3:
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
sub esp, 0x18
mov eax, 114
mov DWORD PTR [ebp-4], eax
mov eax, -114
mov DWORD PTR [ebp-8], eax
mov eax, 514
mov DWORD PTR [ebp-12], eax
mov eax, -514
mov DWORD PTR [ebp-16], eax

mov eax, DWORD PTR [ebp-16]
push eax
mov eax, DWORD PTR [ebp-12]
push eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call print4
add esp, 0x10

mov eax, DWORD PTR [ebp-16]
neg eax
push eax
mov eax, DWORD PTR [ebp-12]
neg eax
push eax
mov eax, DWORD PTR [ebp-8]
neg eax
push eax
mov eax, DWORD PTR [ebp-4]
neg eax
push eax
call print4
add esp, 0x10

mov eax, DWORD PTR [ebp-16]
not eax
push eax
mov eax, DWORD PTR [ebp-12]
not eax
push eax
mov eax, DWORD PTR [ebp-8]
not eax
push eax
mov eax, DWORD PTR [ebp-4]
not eax
push eax
call print4
add esp, 0x10

mov eax, 1
mov DWORD PTR [ebp-4], eax

mov eax, 0
mov DWORD PTR [ebp-8], eax

mov eax, -1
mov DWORD PTR [ebp-12], eax

mov eax, DWORD PTR [ebp-12]
push eax
mov eax, DWORD PTR [ebp-8]
push eax
mov eax, DWORD PTR [ebp-4]
push eax
call print3
add esp, 0xc

mov eax, DWORD PTR [ebp-12]
neg eax
push eax
mov eax, DWORD PTR [ebp-8]
neg eax
push eax
mov eax, DWORD PTR [ebp-4]
neg eax
push eax
call print3
add esp, 0xc

mov eax, DWORD PTR [ebp-12]
not eax
push eax
mov eax, DWORD PTR [ebp-8]
not eax
push eax
mov eax, DWORD PTR [ebp-4]
not eax
push eax
call print3
add esp, 0xc

mov eax, 0
leave
ret

