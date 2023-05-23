CODE SEGMENT
    ASSUME CS:CODE, DS:CODE

        MOV AX, CODE
        MOV DS, AX

        MOV AH, 1       ; key input을 AL에 저장 (echo 있는 입력)
        INT 21H
        MOV KEEP, AL    ; 입력 결과를 변수에 저장

        MOV DL, KEEP
        ADD DL, 1

        MOV AH, 2
        INT 21H

        MOV AH, 4CH
        INT 21H

    KEEP DB ?

CODE ENDS
    END