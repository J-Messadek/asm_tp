section .bss
    result resb 32

section .text
    global _start

_start:
    ; Parse argv[1], argv[2], argv[3]
    mov rsi, [rsp + 16]
    call parse_int
    mov r12, rax            ; first number
    
    mov rsi, [rsp + 24]
    call parse_int
    mov r13, rax            ; second number
    
    mov rsi, [rsp + 32]
    call parse_int
    mov r14, rax            ; third number
    
    ; Find max
    mov rax, r12
    cmp r13, rax
    cmovg rax, r13
    cmp r14, rax
    cmovg rax, r14
    
    ; rax = max, convert to string and print
    ; Handle negative
    xor r15, r15
    test rax, rax
    jns .positive
    neg rax
    mov r15, 1
.positive:
    
    lea rdi, [rel result + 30]
    mov byte [rdi + 1], 10
    mov rcx, 1
    
    test rax, rax
    jnz .conv_loop
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .check_neg

.conv_loop:
    test rax, rax
    jz .check_neg
    xor rdx, rdx
    mov r8, 10
    div r8
    add dl, '0'
    mov byte [rdi], dl
    dec rdi
    inc rcx
    jmp .conv_loop

.check_neg:
    test r15, r15
    jz .do_print
    mov byte [rdi], '-'
    dec rdi
    inc rcx

.do_print:
    inc rdi
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

; Parse signed integer from string at rsi -> rax (signed)
parse_int:
    xor rax, rax
    xor rcx, rcx            ; sign flag
    
    cmp byte [rsi], '-'
    jne .pi_loop
    mov rcx, 1
    inc rsi

.pi_loop:
    movzx rdx, byte [rsi]
    cmp dl, '0'
    jb .pi_done
    cmp dl, '9'
    ja .pi_done
    imul rax, 10
    sub dl, '0'
    add rax, rdx
    inc rsi
    jmp .pi_loop

.pi_done:
    test rcx, rcx
    jz .pi_ret
    neg rax
.pi_ret:
    ret
