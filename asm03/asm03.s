global _start

section .data
    value db '42'
    msg db '1337'
    len equ $ - msg


section .text
_start:
    mov rax, [rsp]
    cmp rax, 2
    jl .failure
    mov rsi, [rsp + 16]
    cmp byte [rsi], '4'
    jne .failure
    cmp byte [rsi + 1], '2'
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