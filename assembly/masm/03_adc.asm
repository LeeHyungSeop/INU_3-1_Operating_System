CODE SEGMENT
    ASSUME CS : CODE, DS : DATA

    MOV AX, DATA
    MOV DS, AX

    MOV AX, 1223H
    MOV BX, 8000H
    MOV CX, 2000H
    MOV DX, 8123H

    ADD BX, DX          ; Carry Flag가 1로 set
    ADC AX, CX          ; Carry와 함께 덧셈

    MOV VAR1, AX 
    MOV VAR2, BX 

    MOV AH, 4CH
    INT 21H

CODE ENDS

DATA SEGMENT    
    VAR1 DW ?           ; 초기화 X
    VAR2 DW ?           ; 초기화 X
DATA ENDS
    END