%include "debug.mac"
section .text
global leap_year
leap_year:
    ; Provide your implementation here
    ; The function has type signature int leap_year(int year)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    
    mov ecx, edi
    and ecx, 0b11
    cmp ecx, 0
    jg .false

    mov eax, edi
    xor edx, edx
    mov esi, 100
    idiv esi
    cmp edx, 0
    jne .true
    
    mov esi, 4
    idiv esi
    cmp edx, 0
    jne .false

    .true:
        xor rax, rax
        inc rax
        ret
    
    .false:
        xor rax, rax
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
