; echo 없는 키보드 입력을 받아서, 소문자 26글자를 입력했을 때만 화면에 출력.
; 그렇지 않을 때는 숫자 0을 출력해 보자.
; 10번 반복하고 나면 program을 종료하도록 해보자.

CODE SEGMENT
    ASSUME CS : CODE

    MOV CX, 1

SUM10 : INC CX

        NEXT : MOV AH, 8         ; AL에 1문자 키보드 입력(echo 없이)
               INT 21H      

        CMP AL, 'a'              ; 키보드 입력과 'A' 비교
        JB PRINT0                ; 키보드 입력 < 'A' 이면 0 출력
        CMP AL, 'z'              ; 키보드 입력과 'Z' 비교
        JA PRINT0                ; 키보드 입력 > 'Z' 이면 0 출력

        PRINT : MOV AH, 2       ; 출력
                MOV DL, AL
                INT 21H
                JMP ISEND

        PRINT0 : MOV AH, 2
                 MOV DL, '0'
                 INT 21H
                 JMP ISEND

        ISEND : CMP CX, 10
                JBE SUM10       


EXIT : MOV AH, 4CH              ; Program 종료
        INT 21H

CODE ENDS
    END