; 문자 하나 입력받아서 대/소문자 구분하고, 바꿔 출력하기

CODE SEGMENT
    ASSUME CS : CODE

       MOV AH, 1                ; AL에 1문자 키보드 입력(echo)
       INT 21H      

       CMP AL, 'a'              ; 키보드 입력과 'Z' 비교
       JAE STEP_SMALL           ; 키보드 입력 > 'Z' 이면 그대로 출력
       CMP AL, 'A'              ; 키보드 입력과 'A' 비교
       JAE STEP_LAR             ; 키보드 입력 < 'A' 이면 그대로 출력


STEP_LAR : 
    CMP AL, 'Z'
    JBE PRINT_SMALL
STEP_SMALL : 
    CMP AL, 'z'
    JBE PRINT_LAR
PRINT_LAR : 
        SUB AL, 'a'-'A'
        MOV DL, AL
        MOV AH, 2
        INT 21H
        JMP EXIT
PRINT_SMALL : 
        ADD AL, 'a'-'A'
        MOV DL, AL
        MOV AH, 2
        INT 21H
        JMP EXIT
EXIT : 
    MOV AH, 4CH              ; Program 종료
    INT 21H

CODE ENDS
    END