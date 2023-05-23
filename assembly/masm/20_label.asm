main segment 

    assume cs : main, ds : main 

    MOV AX, CS 
    MOV DS, AX 

    MOV AX, A 
    ADD AX, B 
    MOV SUM, AX 

    MOV AX, 4C00H
    INT 21H

A DW 2
B DW 5
SUM DW ?

main ends 
    end