global _start

section .data
    compare db '42'
    msg db '1337'
    len equ $ - msg


section .bss
    input resb 2

section .text
_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 2
    syscall

    cmp byte [input], '4'
    jne .failure
    cmp byte [input + 1], '2'
    je .success
    jmp .failure

.success:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.failure:
    mov rax, 60
    mov rdi, 1
    syscall