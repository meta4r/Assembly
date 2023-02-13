section .data
    c db 'A'   ; character to find ASCII value of

section .text
    global _start


_start:
    ; get character from user
    mov eax, [c]

    ; print ASCII value
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
    ; restore
