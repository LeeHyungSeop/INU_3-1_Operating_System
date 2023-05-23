; 2번 프로그램을 변형(소문자가 아니면 무시하고 다시 입력)

CODE SEGMENT
    ASSUME CS : CODE, DS : CODE

    MOV AX, CODE
    MOV DS, AX 

    RETRY : 
        MOV AH, 1       ; echo 있는 입력 받기 (AL에다가)
        INT 21H 

        CMP AL, 'a'
        JB RETRY
        CMP AL, 'z'
        JA RETRY

        ; 이제 소문자인게 확정남
        MOV DL, AL
        SUB DL, 32          ; 'a' - 'A' = 32
        MOV AH, 2
        int 21h     

    MOV AH, 4CH
    INT 21H
CODE ENDS
    END