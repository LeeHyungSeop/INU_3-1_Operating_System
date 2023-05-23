; 소문자 하나 입력받아 대문자로 출력 (소문자만 입력)

CODE SEGMENT
    ASSUME CS : CODE, DS : DATA

    MOV AX, DATA
    MOV DS, AX 

    MOV BL, 'a'
    SUB BL, 'A'
    MOV CHANGE BL

    MOV AH, 1                                   ; echo 있는 입력 받기 (AL에다가)
    INT 21H      

    MOV DL, AL
    SUB DL, CHANGE
    MOV AH, 2
    INT 21H

    MOV AH, 4CH
    INT 21H

CODE ENDS

DATA SEGMENT
    CHANGE ?
DATA ENDS
    END