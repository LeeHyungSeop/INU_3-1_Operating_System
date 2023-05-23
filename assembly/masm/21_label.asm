main segment 

    assume cs : main, ds : main 

A DW 2
B DW 5
SUM DW ?

START :
    MOV AX, A   
    ADD AX, B 
    MOV SUM, AX 

    MOV AX, 4C00H
    INT 21H

main ends 
    end START                   ; 시작점을 지정해줌 (Label, 프로시저, 함수 등을 쓸 수 있다.)