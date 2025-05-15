section .data
    ; Input data (8 bytes)
    inputBuf:   db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputLen:   equ $-inputBuf  ; Calculate length automatically
    
    ; ASCII lookup table for hex digits 0-F
    hexDigits:  db "0123456789ABCDEF"
    
    ; Newline character (ASCII 10)
    newline:    db 10

section .bss
    ; Output buffer (2 chars per byte + spaces + newline)
    outputBuf:  resb 80

section .text
    global _start

_start:
    ; Initialize pointers and counters
    mov esi, inputBuf    ; ESI = pointer to input data
    mov edi, outputBuf   ; EDI = pointer to output buffer
    mov ecx, inputLen    ; ECX = number of bytes to process
    xor ebx, ebx         ; EBX = output position counter (starts at 0)

process_byte:
    ; Process high nibble (first 4 bits)
    mov al, [esi]        ; Load current byte into AL
    shr al, 4            ; Shift right 4 bits to get high nibble
    and al, 0x0F         ; Mask to keep only lower 4 bits
    mov al, [hexDigits + eax] ; Convert to ASCII using lookup table
    mov [edi + ebx], al  ; Store ASCII char in output buffer
    inc ebx              ; Increment output position
    
    ; Process low nibble (last 4 bits)
    mov al, [esi]        ; Reload current byte
    and al, 0x0F         ; Mask to get low nibble
    mov al, [hexDigits + eax] ; Convert to ASCII
    mov [edi + ebx], al  ; Store ASCII char
    inc ebx              ; Increment output position
    
    ; Add space separator (except after last byte)
    cmp ecx, 1           ; Is this the last byte?
    je next_byte         ; If yes, skip space
    mov byte [edi + ebx], ' ' ; Add space
    inc ebx              ; Increment output position

next_byte:
    inc esi              ; Move to next input byte
    loop process_byte    ; Decrement ECX and loop if not zero
    
    ; Add newline at the end
    mov byte [edi + ebx], 10  ; 10 = ASCII for newline
    inc ebx              ; Include newline in count
    
    ; System call to write output to stdout
    mov eax, 4           ; sys_write system call number
    mov ebx, 1           ; File descriptor 1 (stdout)
    mov ecx, outputBuf   ; Pointer to output buffer
    mov edx, ebx         ; Length of output (in EBX)
    int 0x80             ; Call kernel
    
    ; Exit program cleanly
    mov eax, 1           ; sys_exit system call number
    xor ebx, ebx         ; Exit status 0
    int 0x80             ; Call kernel