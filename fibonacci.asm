section .data
    n dd 5   ; number of terms

section .bss
    fib resd 100   ; reserve 100 dwords for fibonacci series

section .text
    global _start

_start:
    ; get number of terms from user
    mov eax, [n]
    mov ebx, eax

    ; initialize first two terms of fibonacci series
    mov [fib], 1
    mov [fib + 4], 1

    ; loop for the remaining terms
    add ebx, 2
    sub ebx, eax
    add ebx, 4
    mov ecx, 2

loop:
    ; calculate next term
    mov eax, [fib + ebx - 4]
    add eax, [fib + ebx - 8]
    mov [fib + ebx], eax

    ; increment counter
    inc ecx

    ; check if all terms have been generated
    cmp ecx, eax
    jne loop

    ; display the fibonacci series
    mov ecx, [n]
    mov ebx, 0

print:
    ; print current term
    mov eax, [fib + ebx]
    add ebx, 4
    call print_number
    loop print

    ; exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; subroutine to print a number
print_number:
    ; convert number to string
    push ebx
    push edx
    push ecx
    mov edx, 10
    mov ecx, 0

convert:
    xor ebx, ebx
    div edx
    add bl, '0'
    push ebx
    inc ecx
    test eax, eax
    jne convert

    ; print the string
    pop eax

print_loop:
    ; check if all characters have been printed
    test ecx, ecx
    jz end
    dec ecx
    call putchar
    jmp print_loop

end:
    ; restore registers
    pop ecx
    pop edx
    pop ebx
    ret

; subroutine to write a character to the screen
putchar:
    ; write character to stdout
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
