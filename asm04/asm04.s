section .bss
    buf resb 256

section .text
    global _start

_start:
    ; Read from stdin
    mov rax, 0
    mov rdi, 0
    lea rsi, [rel buf]
    mov rdx, 256
    syscall
    
    ; Parse the number from input string
    lea rsi, [rel buf]
    xor rax, rax            ; result = 0
    xor rcx, rcx            ; sign flag
    
    ; Check for negative sign
    cmp byte [rsi], '-'
    jne .parse_loop
    mov rcx, 1
    inc rsi

.parse_loop:
    movzx rdx, byte [rsi]
    cmp dl, '0'
    jb .done_parse
    cmp dl, '9'
    ja .done_parse
    
    imul rax, 10
    sub dl, '0'
    add rax, rdx
    inc rsi
    jmp .parse_loop

.done_parse:
    ; Check if even: test bit 0
    test rax, 1
    jnz .odd
    
    ; Even: exit 0
    mov rax, 60
    xor rdi, rdi
    syscall

.odd:
    ; Odd: exit 1
    mov rax, 60
    mov rdi, 1
    syscall
