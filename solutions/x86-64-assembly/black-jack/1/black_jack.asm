; Everything that comes after a semicolon (;) is a comment

%include "debug.mac"

C2 equ 2
C3 equ 3
C4 equ 4
C5 equ 5
C6 equ 6
C7 equ 7
C8 equ 8
C9 equ 9
C10 equ 10
CJ equ 11
CQ equ 12
CK equ 13
CA equ 14

TRUE equ 1
FALSE equ 0

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global value_of_card
value_of_card:
    ; This function takes as parameter a number representing a card
    ; The function should return the numerical value of the passed-in card

    cmp rdi, CJ
    jb .normal_card

    cmp rdi, CA
    je .ace

    mov rax, 10
    ret

    .ace:
        mov rax, 1
        ret
    
    .normal_card:
        mov rax, rdi
        ret

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0

    mov rcx, rdi                ; rcx = card 1

    call value_of_card
    mov r8, rax                 ; r8 = value of card 1

    mov rdi, rsi
    call value_of_card
    mov r9, rax                 ; r9 = value of card 1

    xor rdx, rdx
    
    cmp r8, r9
    ja .first                   ; r8 > r9 -> .first
    jb .second                  ; r8 < r9 -> .second

    mov rax, rcx                ; None is higher
    mov rdx, rdi
    ret

    .first:                     ; First card is higher
        mov rax, rcx
        ret

    .second:                    ; Second card is higher
        mov rax, rdi
        ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace

    call value_of_card

    cmp rdi, CA                 ; If either card is an ace, bust and return 1
    je .bust
    cmp rsi, CA
    je .bust
    
    mov r8, rax                 ; r8 = value of card 1

    mov rdi, rsi
    call value_of_card
    add r8, rax                 ; r8 = total value of hand

    add r8, 11                  ; r8 = value of hand with an ace worth 11

    cmp r8, 21
    ja .bust

    mov rax, 11                 ; r8 <= 21 -> return 11
    ret

    .bust:                      ; r8 > 21 -> bust and return 1
        mov rax, 1
        ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise

    cmp rdi, CA
    je .first_ace

    cmp rdi, C9
    ja .first_ten

    jmp .failure

    .first_ace:
        cmp rsi, CA
        je .failure
        
        cmp rsi, C10
        jae .bj
        
        jmp .failure

    .first_ten:
        cmp rsi, CA
        je .bj

        jmp .failure

    .bj:
        mov rax, TRUE
        ret

    .failure:
        mov rax, FALSE
        ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise

    call value_of_card
    mov r8, rax

    mov rdi, rsi
    call value_of_card

    cmp rax, r8
    je .possible

    mov rax, FALSE
    ret

    .possible:
        mov rax, TRUE
        ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise

    call value_of_card
    mov r8, rax

    mov rdi, rsi
    call value_of_card
    add r8, rax

    cmp r8, 9
    je .possible

    cmp r8, 10
    je .possible

    cmp r8, 11
    je .possible

    mov rax, FALSE
    ret
    
    .possible:
        mov rax, TRUE
        ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
