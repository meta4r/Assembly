section .data
    msg db 'Hello, World!', 0   ; null-terminated string

section .text
    global _start

_start:

    ; write string to stdout
    mov eax, 4      ; system call number (sys_write)
    mov ebx, 1      ; file descriptor (stdout)
    mov ecx, msg    ; pointer to message
    mov edx, 13     ; length of message
    int 0x80        ; make system call

    ; exit program
    mov eax, 1      ; system call number (sys_exit)
    xor ebx, ebx    ; exit status code
    int 0x80        ; make system call
