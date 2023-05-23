main segment 
    assume cs : main, ds : main 

START :
    MOV AX, CS 
    MOV DS, AX

    MOV AL, A   
    ADD AL, B 
    MOV SUM, AL

    MOV AX, 4C00H
    INT 21H

A DB 0FFH           ; 0013
B DB 1              ; 0014
SUM DB ?            ; 0015

main ends 
    end  START