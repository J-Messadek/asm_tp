section .data
    hex_chars db "0123456789ABCDEF"

section .bss
    result resb 128

section .text
    global _start

_start:
    mov r12, [rsp]          ; argc
    
    ; Default mode: hex
    ; If argv[1] == "-b", mode = binary, number is argv[2]
    ; Otherwise, number is argv[1]
    
    xor r13, r13            ; 0 = hex mode, 1 = binary mode
    mov r14, [rsp + 16]     ; default: argv[1] is the number
    
    cmp r12, 3
    jl .parse_number
    
    ; Check if argv[1] is "-b"
    mov rsi, [rsp + 16]
    cmp byte [rsi], '-'
    jne .parse_number
    cmp byte [rsi + 1], 'b'
    jne .parse_number
    cmp byte [rsi + 2], 0
    jne .parse_number
    
    ; Binary mode
    mov r13, 1
    mov r14, [rsp + 24]    ; argv[2] is the number

.parse_number:
    ; Parse decimal number from r14
    mov rsi, r14
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
    mov rbx, rax            ; rbx = number
    
    test r13, r13
    jnz .to_binary

.to_hex:
    ; Convert to hex string
    lea rdi, [rel result + 126]
    mov byte [rdi + 1], 10  ; newline
    mov rcx, 1
    
    test rbx, rbx
    jnz .hex_loop
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .do_print

.hex_loop:
    test rbx, rbx
    jz .do_print
    mov rax, rbx
    and rax, 0xF
    lea rsi, [rel hex_chars]
    mov al, [rsi + rax]
    mov byte [rdi], al
    dec rdi
    inc rcx
    shr rbx, 4
    jmp .hex_loop

.to_binary:
    ; Convert to binary string
    lea rdi, [rel result + 126]
    mov byte [rdi + 1], 10  ; newline
    mov rcx, 1
    
    test rbx, rbx
    jnz .bin_loop
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .do_print

.bin_loop:
    test rbx, rbx
    jz .do_print
    mov rax, rbx
    and rax, 1
    add al, '0'
    mov byte [rdi], al
    dec rdi
    inc rcx
    shr rbx, 1
    jmp .bin_loop

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
