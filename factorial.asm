section .data
    n db 5   ; number to calculate factorial of

section .bss
    result resd 1   ; result of calculation

section .text
    global _start

_start:
    ; get number from user
    mov eax, [n]

    ; initialize result
    mov [result], 1

    ; calculate factorial
    mov ebx, eax

loop:
    ; check if we have reached the end of the calculation
    cmp ebx, 1
    jle end

    ; multiply result by current number
    mov eax, [result]
    mul ebx

    ; update result and counter
    mov [result], eax
    dec ebx
    jmp loop

end:
    ; print result
    mov eax, [result]
    call print_number

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
