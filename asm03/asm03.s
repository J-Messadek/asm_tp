section .data
    msg db "1337", 10

section .text
    global _start

_start:
    ; [rsp] = argc, [rsp+8] = argv[0], [rsp+16] = argv[1]
    
    ; Check argc >= 2
    cmp qword [rsp], 2
    jl .fail
    
    ; Get argv[1]
    mov rsi, [rsp + 16]
    
    ; Check first char is '4'
    cmp byte [rsi], '4'
    jne .fail
    
    ; Check second char is '2'
    cmp byte [rsi + 1], '2'
    jne .fail
    
    ; Check third char is null terminator
    cmp byte [rsi + 2], 0
    jne .fail
    
    ; Print "1337\n"
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel msg]
    mov rdx, 5
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.fail:
    mov rax, 60
    mov rdi, 1
    syscall
