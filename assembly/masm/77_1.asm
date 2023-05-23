; 화면에서 문자 하나 입력받아 그대로 다시 출력

CODE SEGMENT
    ASSUME CS:CODE

        MOV AX, CODE
        MOV DS, AX

        MOV AH, 1       ; key input을 AL에 저장 (echo 있는 입력)
        INT 21H

        MOV DL, AL    ; 입력 결과를 DL에 저장
        MOV AH, 2
        INT 21H

        MOV AH, 4CH
        INT 21H

CODE ENDS
    END