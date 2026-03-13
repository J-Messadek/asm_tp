global _start

section .text
_start:
    ;sys_exit(0)
    mov rax, 60
    mov rdi, 0
    syscall