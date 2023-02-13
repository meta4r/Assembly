section .data
prompt db 'Enter the calculation: ', 0
result db 'The result is: ', 0
error db 'Error: Divide by zero.', 0

section .bss
input_buf resb 10
input_len resd 1
input_ptr resd 1

stack resb 100
stack_ptr resd 1

section .text
extern printf, scanf, getchar


global _start

_start:
    ; Read input
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 12
    int 0x80

    ; Read input string
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 10
    int 0x80

    ; Parse and evaluate expression
    mov eax, input_buf
    mov ebx, input_ptr
    call parse_expression

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 11
    int 0x80

    ; Call print_int
    call print_int

    ; Call print_newline
    call print_newline

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Print int
print_int:
    push ebx
    push ecx
    push edx

    ; Convert integer to string
    mov ebx, 10
    mov ecx, input_buf
    mov edx, 0

convert_loop:
    xor edx, edx
    div ebx
    add edx, '0'
    dec ecx
    mov [ecx], dl
    cmp eax, 0
    jne convert_loop

    ; Print string
    mov eax, 4
    mov ebx, 1
    mov ecx, input_buf
    mov edx, 10
    int 0x80

    pop edx
    pop ecx
    pop ebx
    ret

; Print newline
print_newline:
    push ebx

    ; System call
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    pop ebx
    ret

; Parse expression
parse_expression:
    push ebp
    mov ebp, esp

    ; Clear stack pointer
    xor esp, esp

    ; Loop through input string
parse_loop:
    ; Get next character
    mov al, [eax]
    inc eax

    ; Check for end of string
    cmp al, 0
    je parse_done

    ; Check for whitespace
    cmp al, ' '
    je parse_loop

    ; Check for digit
    cmp al, '0'
    jl parse_operator
    cmp al, '9'
    jg parse_operator

    ; Parse digit
    push eax
    call parse_number

    ; Push result to stack
    push eax

    ; Continue parsing
    jmp parse_loop

; Parse operator
parse_operator:
    ; Check for addition
    cmp al, '+'
    je parse_add

    ; Check for subtraction
    cmp al, '-'
    je parse_sub

    ; Check for multiplication
    cmp al, '*'
    je parse_mul

    ; Check for division
    cmp al, '/'
    je parse_div

    ; Invalid operator
    ; ...

    ; Continue parsing
    jmp parse_loop

; Parse add
parse_add:
    ; Pop first operand
    pop ebx

    ; Pop second operand
    pop eax

    ; Perform addition
    add eax, ebx

    ; Push result to stack
    push eax

    ; Continue parsing
    jmp parse_loop

; Parse subtract
parse_sub:
    ; Pop first operand
    pop ebx

    ; Pop second operand
    pop eax

    ; Perform subtraction
    sub eax, ebx

    ; Push result to stack
    push eax

    ; Continue parsing
    jmp parse_loop

; Parse multiply
parse_mul:
    ; Pop first operand
    pop ebx

    ; Pop second operand
    pop eax

    ; Perform multiplication
    mul ebx

    ; Push result to stack
    push eax

    ; Continue parsing
    jmp parse_loop

; Parse divide
parse_div:
    ; Pop first operand
    pop ebx

    ; Pop second operand
    pop eax

    ; Check for divide by zero
    cmp ebx, 0
    je divide_by_zero

    ; Perform division
    div ebx

    ; Push result to stack
    push eax

    ; Continue parsing
    jmp parse_loop

; Parse number
parse_number:
    ; Set result to 0
    xor eax, eax

    ; Loop through digits
number_loop:
    cmp byte [edi], '0'
    jl error
    cmp byte [edi], '9'
    jg operator_loop
    ; Parse the number
    mov cl, [edi]
    sub cl, '0'
    imul ebx, 10
    add ebx, ecx
    inc edi
    jmp number_loop

operator_loop:
    ; Parse the operator
    cmp byte [edi], '+'
    je addition
    cmp byte [edi], '-'
    je subtraction
    cmp byte [edi], '*'
    je multiplication
    cmp byte [edi], '/'
    je division
    jmp error

addition:
    ; Evaluate the expression
    push ebx
    call parse_number
    pop ecx
    add ebx, ecx
    inc edi
    jmp operator_loop

subtraction:
    ; Evaluate the expression
    push ebx
    call parse_number
    pop ecx
    sub ebx, ecx
    inc edi
    jmp operator_loop

multiplication:
    ; Evaluate the expression
    push ebx
    call parse_number
    pop ecx
    imul ebx, ecx
    inc edi
    jmp operator_loop

division:
    ; Evaluate the expression
    push ebx
    call parse_number
    pop ecx
    cmp ecx, 0
    je error
    mov eax, ebx
    cdq
    idiv ecx
    mov ebx, eax
    inc edi
    jmp operator_loop

    ret
