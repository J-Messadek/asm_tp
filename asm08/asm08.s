section .bss
    result resb 32

section .text
    global _start

_start:
    ; Check argc >= 2
    cmp qword [rsp], 2
    jl .exit_fail
    
    ; Parse argv[1]
    mov rsi, [rsp + 16]
    xor rax, rax

.parse:
    movzx rdx, byte [rsi]
    cmp dl, '0'
    jb .parsed
    cmp dl, '9'
    ja .parsed
    imul rax, 10
    sub dl, '0'
    add rax, rdx
    inc rsi
    jmp .parse

.parsed:
    ; Sum = 1 + 2 + ... + (N-1) = N*(N-1)/2
    ; rax = N
    test rax, rax
    jz .print_zero
    
    dec rax                 ; N-1
    mov rbx, rax
    inc rax                 ; N again
    imul rax, rbx           ; N * (N-1)
    shr rax, 1              ; / 2
    
    jmp .convert

.print_zero:
    ; result is 0
    ; rax already 0, fall through

.convert:
    ; Convert rax to string
    lea rdi, [rel result + 30]
    mov byte [rdi + 1], 10  ; newline
    mov rcx, 1
    
    test rax, rax
    jnz .conv_loop
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .do_print

.conv_loop:
    test rax, rax
    jz .do_print
    xor rdx, rdx
    mov r8, 10
    div r8
    add dl, '0'
    mov byte [rdi], dl
    dec rdi
    inc rcx
    jmp .conv_loop

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

.exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall
