section .data
    fmt db "%d", 0xD, 0xA, 0  ; Output format: number + newline
    newline db 0xD, 0xA, 0     ; Separate newline for Windows

section .text
    global main
    extern printf, ExitProcess   ; External functions from C library

main:
    push rbp                    ; Standard function prologue
    mov rbp, rsp
    sub rsp, 32                 ; Allocate shadow space for Windows calling convention

    mov r12, 1000               ; Start from 1000 (first 4-digit number)

check_range:
    cmp r12, 9999               ; Check if we've reached 9999
    jg end_program              ; If greater, end program

    mov rcx, r12                ; Prepare number to check
    call is_prime               ; Call prime checking function
    test al, al                 ; Test return value (1=prime, 0=not prime)
    jz next_number              ; If not prime, skip printing

    ; Print the prime number
    mov rcx, fmt                ; First arg: format string
    mov rdx, r12                ; Second arg: the number
    call printf                 ; Call printf

next_number:
    inc r12                     ; Move to next number
    jmp check_range             ; Repeat loop

end_program:
    xor ecx, ecx                ; Exit code 0
    call ExitProcess            ; Terminate program

; Prime checking function (input in RCX, output in AL: 1=prime, 0=not prime)
is_prime:
    cmp rcx, 2                  ; Numbers less than 2 are not prime
    jl not_prime
    je is_prime_true            ; 2 is prime

    test cl, 1                  ; Check if even number
    jz not_prime                ; Even numbers >2 are not prime

    mov r8, 3                   ; Start checking from divisor 3

check_divisor:
    mov rax, rcx                ; Prepare for division
    xor rdx, rdx                ; Clear remainder
    div r8                      ; Divide number by current divisor
    test rdx, rdx               ; Check remainder
    jz not_prime                ; If remainder=0, not prime

    add r8, 2                   ; Check next odd divisor
    mov rax, r8                 ; Check if divisor^2 <= number
    mul r8
    cmp rax, rcx
    jle check_divisor           ; Continue if more divisors to check

is_prime_true:
    mov al, 1                   ; Return true (prime)
    ret

not_prime:
    xor al, al                  ; Return false (not prime)
    ret