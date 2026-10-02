section .data
    prompt db "Enter a number (1000-9999, 0 to exit): ", 0
    prime_msg db " is prime.", 0xD, 0xA, 0
    not_prime_msg db " is not prime.", 0xD, 0xA, 0
    input_fmt db "%d", 0
    output_fmt db "%d", 0
    newline db 0xD, 0xA, 0

section .bss
    number resd 1

section .text
    global main
    extern printf, scanf, ExitProcess

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

input_loop:
    ; Display prompt
    mov rcx, prompt
    call printf

    ; Get user input
    mov rcx, input_fmt
    lea rdx, [number]
    call scanf

    ; Check for exit condition (0)
    cmp dword [number], 0
    je exit_program

    ; Check if prime
    mov ecx, [number]
    call is_prime

    ; Display the number
    mov rcx, output_fmt
    mov edx, [number]
    call printf

    ; Display appropriate message
    test al, al
    jz .not_prime

    mov rcx, prime_msg
    call printf
    jmp input_loop

.not_prime:
    mov rcx, not_prime_msg
    call printf
    jmp input_loop

exit_program:
    xor ecx, ecx
    call ExitProcess

is_prime:
    cmp rcx, 2
    jl .not_prime
    je .is_prime

    test cl, 1
    jz .not_prime

    mov r8, 3

.check_divisor:
    mov rax, rcx
    xor rdx, rdx
    div r8
    test rdx, rdx
    jz .not_prime

    add r8, 2
    mov rax, r8
    mul r8
    cmp rax, rcx
    jle .check_divisor

.is_prime:
    mov al, 1
    ret

.not_prime:
    xor al, al
    ret