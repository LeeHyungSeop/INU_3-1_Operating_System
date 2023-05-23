; CS와 DS가 분리되어 존재하는 example
; CS 내에 Data를 정의하도록 수정해보시오.

CODE SEGMENT
    ASSUME CS : CODE, DS : DATA

    MOV AX, DATA
    MOV DS, AX 

    MOV DL, SCR_1
    MOV AH, 2
    INT 21H

    MOV CX, SCR_2
    MOV DL, CH 
    MOV AH, 2
    INT 21H

    MOV DL, CL
    MOV AH, 2
    INT 21H

    MOV AH, 4CH
    INT 21H

CODE ENDS

DATA SEGMENT
    SCR_1 DB 'A'        ; 1 Byte
    SCR_2 DW 4243H      ; 2 Bytes
DATA ENDS
    END