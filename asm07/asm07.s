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
    
    ; Parse number
    lea rsi, [rel buf]
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
    mov rbx, rax            ; rbx = number to test
    
    ; 0 and 1 are not prime
    cmp rbx, 2
    jl .not_prime
    je .is_prime
    
    ; Check if even
    test rbx, 1
    jz .not_prime
    
    ; Check odd divisors from 3 to sqrt(n)
    mov rcx, 3              ; divisor

.check_loop:
    mov rax, rcx
    imul rax, rcx
    cmp rax, rbx
    ja .is_prime            ; divisor^2 > n, it's prime
    
    mov rax, rbx
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz .not_prime           ; divisible, not prime
    
    add rcx, 2
    jmp .check_loop

.is_prime:
    mov rax, 60
    xor rdi, rdi            ; exit 0
    syscall

.not_prime:
    mov rax, 60
    mov rdi, 1              ; exit 1
    syscall
