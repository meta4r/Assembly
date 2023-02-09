section .data
    msg db 'madam', 0   ; string to check

section .bss
    len resd 1   ; length of string

section .text
    global _start

_start:
    ; get length of string
    mov eax, [msg]
    call strlen
    mov [len], eax

    ; check if string is a palindrome
    mov eax, [msg]
    call is_palindrome

    ; print result
    cmp al, 1
    jne not_palindrome
    mov eax, 4
    mov ebx, 1
    mov ecx, 'y'
    mov edx, 1
    int 0x80
    jmp end

not_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, 'n'
    mov edx, 1
    int 0x80

end:
    ; exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; subroutine to get length of string
strlen:
    push ebx
    push ecx
    mov ebx, eax

loop:
    cmp byte [ebx], 0
    jz end
    inc ebx
    inc ecx
    jmp loop

end:
    pop ecx
    pop ebx
    ret

; subroutine to check if string is a palindrome
is_palindrome:
    push ebx
    push ecx
    push edx
    mov ebx, eax
    mov ecx, [len]
    mov edx, [len]
    shr edx, 1

loop:
    cmp edx, 0
    jz end
    dec edx
    dec ecx
    mov al, [ebx+ecx-1]
    cmp al, [ebx+edx]
    jne not_palindrome
    jmp loop

end:
    mov al, 1
    pop edx
    pop ecx
    pop ebx
    ret

; subroutine to write a character to the screen
putchar:
    ; write character to stdout
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
