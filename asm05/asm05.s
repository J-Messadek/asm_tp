section .text
    global _start

_start:
    ; Check argc >= 2
    cmp qword [rsp], 2
    jl .exit
    
    ; Get argv[1]
    mov rsi, [rsp + 16]
    
    ; Calculate string length
    mov rdi, rsi
    xor rcx, rcx
.strlen:
    cmp byte [rdi + rcx], 0
    je .print
    inc rcx
    jmp .strlen

.print:
    ; Write the string
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; fd: stdout
    ; rsi already points to argv[1]
    mov rdx, rcx            ; length
    syscall
    
    ; Write newline
    push 10                 ; newline on stack
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
