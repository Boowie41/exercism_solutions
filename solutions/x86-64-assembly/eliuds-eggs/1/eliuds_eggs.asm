%include "debug.mac"
section .text
global egg_count
egg_count:
    ; Provide your implementation here
    ; The function has type signature int egg_count(int number)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    xor rax, rax
    xor rcx, rcx         ; loop index
    .loop:
        mov r10, 1     ; mask
        shl r10, cl
        and r10, rdi
        shr r10, cl
        add rax, r10
        inc rcx
        cmp rcx, 32
        jl .loop
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
