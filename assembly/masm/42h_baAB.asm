; 대문자를 넣으면 +1, 소문자 넣으면 -1
; A → B , Z일 때는 +1 안함
; b → a , a일 때는 -1 안함

CODE SEGMENT
    ASSUME CS : CODE

NEXT : 
       MOV AH, 1                ; AL에 1문자 키보드 입력(echo)
       INT 21H      

       CMP AL, ' '              ; 20H == 'space bar'
       JE EXIT                  ; space bar 누르면 EXIT label로 JUMP

       CMP AL, 'a'              ; 키보드 입력과 'Z' 비교
       JAE STEP_SMALL               ; 키보드 입력 > 'Z' 이면 그대로 출력
       CMP AL, 'A'              ; 키보드 입력과 'A' 비교
       JAE STEP_LAR                 ; 키보드 입력 < 'A' 이면 그대로 출력

        JMP NEXT

STEP_LAR : 
    CMP AL, 'Z'
    JE PRINT
    CMP AL, 'A'
    JE PRINT
    CMP AL, 'Z'                 ; 대문자인게 확정남
    JB PRINT_LAR
STEP_SMALL : 
    CMP AL, 'z'
    JE PRINT
    CMP AL, 'a'
    JE PRINT
    CMP AL, 'z'                 ; 대문자인게 확정남
    JB PRINT_SMALL
PRINT_LAR : 
        MOV DL, AL
        ADD DL, 1
        MOV AH, 2
        INT 21H
        JMP NEXT
PRINT_SMALL : 
        MOV DL, AL
        SUB DL, 1
        MOV AH, 2
        INT 21H
        JMP NEXT
PRINT : 
    MOV DL, AL
    MOV AH, 2
    INT 21H
    JMP NEXT
    

EXIT : MOV AH, 4CH              ; Program 종료
        INT 21H

CODE ENDS
    END