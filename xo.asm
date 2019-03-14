;Copyright (c) 2019 Grzegorz Raczek
;https://github.com/grzracz
;Files available under MIT license

global main

extern printf
extern scanf

section .data

instrukcja: db 'Please enter the number of the field on which the next symbol is to be placed.',10,0
instrukcja2: db 'Current symbol is: %c',10,0         ;%c - character, %d - decimal number
wygrana: db 'Player with the sign %c won!',10,0
koniec_gry: db 'Game over.',10,0
remis: db 'Draw.',10,0
linia: db ' %c | %c | %c ',10,0 ;line with parameters (X | O | X)
linia2: db '--- --- ---',10,0   ;line without parameters
format: db '%d',0               ;format, for printf and scanf
endl: db 10,0                   ;empty line
clear: db   27,'[H',27,'[2J'    ;clear unix terminal


section .bss                ;resd - reserve doubleword, dword = 4 bytes
pole: resd 10            ;game fields, last field is the current symbol
temp: resd 1             ;location input
runda: resd 1            ;round number

section .text

main:

mov dword [pole], 49              ;numbers from 1-9 placed on the field, 88 - X, 79 - O
mov dword [pole + 4], 50          ; +4 because using dword (4 bytes)
mov dword [pole + 8], 51
mov dword [pole + 12], 52
mov dword [pole + 16], 53
mov dword [pole + 20], 54
mov dword [pole + 24], 55
mov dword [pole + 28], 56
mov dword [pole + 32], 57
mov dword [pole + 36], 88         ;x symbol starts the game
mov dword [temp], 0               ;zeroing input
mov dword [runda], 0              ;zerowanie round number

call wyczysc_ekran
call wypisz_instrukcje
call wypisz_tablice

mov dword [pole], 32              ;changing the numbers on the field to spaces
mov dword [pole + 4], 32
mov dword [pole + 8], 32
mov dword [pole + 12], 32
mov dword [pole + 16], 32
mov dword [pole + 20], 32
mov dword [pole + 24], 32
mov dword [pole + 28], 32
mov dword [pole + 32], 32

call wczytaj
call zapisz
call zmien_znak
call zwieksz_runde

petla:                              ;main loop
call wyczysc_ekran                  
call wypisz_instrukcje
call wypisz_tablice
call sprawdz
cmp dword [runda], 9
je wypisz_remis
call wczytaj
call zapisz
call zmien_znak
call zwieksz_runde
jmp petla

wyczysc_ekran:                      ;clear screen
mov rdi, clear
xor rax, rax
call printf
ret

zmien_znak:
cmp dword [pole + 36], 80           ;check current sign and change it to the other one
mov r8d, 79
mov r9d, 88
cmova ecx, r8d
cmovb ecx, r9d
mov [pole + 36], ecx
ret

wypisz_instrukcje:
cmp dword [runda], 9                ;check if game is still going
je wse
mov rdi, instrukcja                 ;1st instruction
xor rax, rax
call printf
mov rdi, instrukcja2                ;2nd instruction
mov rsi, [pole + 36]
xor rax, rax
call printf
mov rdi, endl                       ;empty line
xor rax, rax
call printf
ret
wse:                                ;if game is ended
mov rdi, koniec_gry
xor rax, rax
call printf
mov rdi, endl                       ;empty line
xor rax, rax
call printf
mov rdi, endl                       ;empty line
xor rax, rax
call printf
ret

wypisz_tablice:
mov rdi, linia                      ;show the field
mov rsi, [pole]
mov rdx, [pole + 4]
mov rcx, [pole + 8]
xor rax, rax
call printf
mov rdi, linia2
xor rax, rax
call printf
mov rdi, linia
mov rsi, [pole + 12]
mov rdx, [pole + 16]
mov rcx, [pole + 20]
xor rax, rax
call printf
mov rdi, linia2
xor rax, rax
call printf
mov rdi, linia                      ;end of the field
mov rsi, [pole + 24]
mov rdx, [pole + 28]
mov rcx, [pole + 32]
xor rax, rax
call printf
mov rdi, endl                       ;empty line
xor rax, rax
call printf
ret

wczytaj:                            ;user input
mov rdi, format                     
mov rsi, temp
xor rax, rax
call scanf
cmp rax, 0              ;end program if incorrect input
je koniec
ret

zapisz:                             ;check which number was selected by user
mov ecx, [pole + 36]                ;move current symbol to dword register
cmp dword [temp], 1
je rowne1 
cmp dword [temp], 2
je rowne2
cmp dword [temp], 3
je rowne3
cmp dword [temp], 4
je rowne4
cmp dword [temp], 5
je rowne5
cmp dword [temp], 6
je rowne6
cmp dword [temp], 7
je rowne7
cmp dword [temp], 8
je rowne8
cmp dword [temp], 9
je rowne9
stop:                                ;if incorrect number
cmp dword [pole + 36], 80            ;check current sign and change it to the other one
mov r8d, 79
mov r9d, 88
cmova ecx, r8d
cmovb ecx, r9d
mov [pole + 36], ecx
mov ecx, [runda]                      ;--round number
sub ecx, 1
mov dword [runda], ecx
ret

rowne1:
cmp dword [pole], 88                ;check if that field area was already used
je stop
cmp dword [pole], 79               
je stop
mov dword [pole], ecx               ;change that field area to current sign
ret
rowne2:
cmp dword [pole + 4], 88
je stop
cmp dword [pole + 4], 79
je stop
mov dword [pole + 4], ecx
ret
rowne3:
cmp dword [pole + 8], 88
je stop
cmp dword [pole + 8], 79
je stop
mov dword [pole + 8], ecx
ret
rowne4:
cmp dword [pole + 12], 88
je stop
cmp dword [pole + 12], 79
je stop
mov dword [pole + 12], ecx
ret
rowne5:
cmp dword [pole + 16], 88
je stop
cmp dword [pole + 16], 79
je stop
mov dword [pole + 16], ecx
ret
rowne6:
cmp dword [pole + 20], 88
je stop
cmp dword [pole + 20], 79
je stop
mov dword [pole + 20], ecx
ret
rowne7:
cmp dword [pole + 24], 88
je stop
cmp dword [pole + 24], 79
je stop
mov dword [pole + 24], ecx
ret
rowne8:
cmp dword [pole + 28], 88
je stop
cmp dword [pole + 28], 79
je stop
mov dword [pole + 28], ecx
ret
rowne9:
cmp dword [pole + 32], 88
je stop
cmp dword [pole + 32], 79
je stop
mov dword [pole + 32], ecx
ret

testuj:             ;check memory values
mov rdi, format         ;test1
mov rsi, [pole]
xor rax, rax
call printf
mov rdi, format         ;test2
mov rsi, [pole + 4]
xor rax, rax
call printf
mov rdi, format         ;test3
mov rsi, [pole + 8]
xor rax, rax
call printf
mov rdi, format          ;test4
mov rsi, [pole + 12]
xor rax, rax
call printf
mov rdi, format          ;test5
mov rsi, [pole + 16]
xor rax, rax
call printf
mov rdi, format          ;test6
mov rsi, [pole + 20]
xor rax, rax
call printf
mov rdi, format          ;test7
mov rsi, [pole + 24]
xor rax, rax
call printf
mov rdi, format          ;test8
mov rsi, [pole + 28]
xor rax, rax
call printf
mov rdi, format          ;test9
mov rsi, [pole + 32]
xor rax, rax
call printf
mov rdi, format          ;test sign
mov rsi, [pole + 36]
xor rax, rax
call printf
mov rdi, format          ;test input
mov rsi, [temp]
xor rax, rax
call printf
mov rdi, format          ;test round number
mov rsi, [runda]
xor rax, rax
call printf
ret

zwieksz_runde:  ;increase round number
mov ecx, [runda]
add ecx, 1
mov dword [runda], ecx
ret

sprawdz:
mov ecx, [pole]         ;check if winning condition is met
cmp dword ecx, 32       ;check if space is at this field area
je war2
cmp ecx, [pole + 4]     ;row 1
jne war1_1
cmp ecx, [pole + 8]
je wypisz_wygrana
war1_1:
cmp ecx, [pole + 12]    ;column 1
jne war1_2
cmp ecx, [pole + 24]
je wypisz_wygrana
war1_2:
cmp ecx, [pole + 16]    ;diagonal 1
jne war2
cmp ecx, [pole + 32]
je wypisz_wygrana

war2:
mov ecx, [pole + 12]   
cmp dword ecx, 32
je war3
cmp ecx, [pole + 16]    ;row 2
jne war3
cmp ecx, [pole + 20]
je wypisz_wygrana                  

war3:
mov ecx, [pole + 24]    ;field 7
cmp dword ecx, 32
je war4
cmp ecx, [pole + 28]    ;row 3
jne war3_1
cmp ecx, [pole + 32]
je wypisz_wygrana           
war3_1:
cmp ecx, [pole + 16]    ;diagonal 2
jne war4
cmp ecx, [pole + 8]
je wypisz_wygrana

war4:
mov ecx, [pole + 4]     ;field 2
cmp dword ecx, 32
je war5                   
cmp ecx, [pole + 16]
jne war5                ;column 2
cmp ecx, [pole + 28]
je wypisz_wygrana

war5:
mov ecx, [pole + 8]     ;field 3
cmp dword ecx, 32
je war6
cmp ecx, [pole + 20]
jne war6                 ;column 3
cmp ecx, [pole + 32]
je wypisz_wygrana

war6:
ret

wypisz_wygrana:                 ;print winner and end program
cmp dword [pole + 36], 80
mov r8d, 79
mov r9d, 88
cmova ecx, r8d
cmovb ecx, r9d
mov [pole + 36], ecx
mov rdi, wygrana
mov rsi, [pole + 36]
xor rax, rax
call printf
jmp koniec

wypisz_remis:                   ;print draw and end program
mov rdi, remis
xor rax, rax
call printf

koniec:
mov	rax,1
mov	rbx,1
int	80h
