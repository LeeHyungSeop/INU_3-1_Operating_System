CODE SEGMENT
    ASSUME CS : CODE

NEXT : MOV AH, 1                ; AL에 1문자 키보드 입력(echo)
       INT 21H      

       CMP AL, ' '              ; 20H == 'space bar'
       JE EXIT                  ; space bar 누르면 EXIT label로 JUMP

       CMP AL, 'A'              ; 키보드 입력과 'A' 비교
       JB PRINT                 ; 키보드 입력 < 'A' 이면 그대로 출력
       CMP AL, 'Z'              ; 키보드 입력과 'Z' 비교
       JA PRINT                 ; 키보드 입력 > 'Z' 이면 그대로 출력

       ADD AL, 'a'-'A'          ; 'A' <= 키보드 입력 <= 'Z'면 소문자로 변환

PRINT : MOV AH, 2
        MOV DL, AL
        INT 21H
        JMP NEXT

EXIT : MOV AH, 4CH              ; Program 종료
        INT 21H

CODE ENDS
    END