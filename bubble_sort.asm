section .data
    arr db 5, 2, 4, 6, 1, 3   ; array to be sorted
    size equ $-arr   ; size of array

section .text
    global _start

_start:
    ; call bubble sort
    call bubble_sort

    ; print sorted array
    mov eax, 4
    mov ebx, 1
    mov ecx, arr
    mov edx, size
    int 0x80

    ; exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; subroutine to sort an array using bubble sort
bubble_sort:
    push ebx
    push ecx
    push edx
    mov ebx, size
    mov ecx, 1

outer_loop:
    cmp ebx, 1
    jle end
    dec ebx
    mov edx, 0

inner_loop:
    cmp edx, ebx
    jge next
    mov al, [arr+edx]
    cmp al, [arr+edx+1]
    jle next
    mov ah, [arr+edx+1]
    mov [arr+edx+1], al
    mov [arr+edx], ah

next:
    inc edx
    jmp inner_loop

end:
    pop edx
    pop ecx
    pop ebx
    ret
