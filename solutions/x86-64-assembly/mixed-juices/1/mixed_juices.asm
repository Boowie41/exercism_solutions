; Everything that comes after a semicolon (;) is a comment
%include "debug.mac"
section .data

drinks_time dd 1, 3, 3, 4, 5, 4, 7, 10

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global time_to_make_juice
time_to_make_juice:
    ; This function has one argument, the ID for a juice as a 32-bit number
    ; It returns the time to prepare this juice, as a 32-bit number
    dec rdi
    lea rdx, [rel drinks_time]
    mov eax, dword [rdx + rdi*4]
    ret

; TODO: define the 'time_to_prepare' function
; This function has two arguments:
; - An array with the IDs for ordered juices, each ID a 32-bit number
; - The number of ordered juices, also a 32-bit number.
; It returns the total time to prepare all ordered juices, as a 32-bit number

global time_to_prepare
time_to_prepare:
    mov r10, rdi
    xor rdi, rdi
    xor r11, r11
    .loop:
        mov edi, dword [r10 + rsi*4 - 4]
        call time_to_make_juice
        add r11, rax
        sub rsi, 1
        jnz .loop

    mov rax, r11
    ret

; TODO: define the 'limes_to_cut' function
; This function takes three arguments:
; - The number of wedges needed, as a 32-bit number.
; - An array with the current supply of limes, each represented by a 8-bit number.
; - The number of limes in the supply, as a 32-bit number.
; It returns the number of limes that need to be cut, as a 32-bit number

global limes_to_cut
limes_to_cut:
    xor r10, r10
    xor rax, rax
    .loop:
        mov r11b, byte [rsi + rax]
        add r10, 6
        cmp r11b, 'S'
        je .end
        add r10, 2
        cmp r11b, 'M'
        je .end
        add r10, 2
        .end:
            inc rax
            cmp r10, rdi
        jl .loop
    ret

; TODO: define the 'remaining_orders' function
; This function takes two arguments:
; - The time left in the shift, as a 32-bit number.
; - An array  with the IDs for ordered juices still not prepared, each ID a 32-bit number.
; It returns the number of juices made before the shift ends, as a 32-bit number.
; You may consider that:
; - The array is never empty.
; - The time left in the shift at the beginning is always greater than 0.
; - There are more orders in the array than that which can be prepared before the shift ends.
global remaining_orders
remaining_orders:
    xor r10, r10
    xor rcx, rcx
    mov r9, rdi
    xor rdi, rdi

    .loop:
        mov edi, dword [rsi + r10*4]
        call time_to_make_juice
        add rcx, rax
        inc r10
        cmp rcx, r9
        jl .loop
    mov rax, r10
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
