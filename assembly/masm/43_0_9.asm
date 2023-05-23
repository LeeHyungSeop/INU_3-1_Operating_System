; Subroutine 사용법
; ex) 0~9 숫자를 문자로 바꾸어 출력



; cmp cl, 52

; ex. 거꾸로 출력하라. 소문자 먼저 출력하고 대문자 출력,
; ex. 홀수만 출력하라. 짝수는 출력하지 마라
; ex. 모음은 출력하지 마라. (이거는 규칙이 없어서 직접 데이터를 갖고 직접 하나하나 물어봐야 한다.)

CODE SEGMENT
    ASSUME CS: CODE
    MOV CL, 0

NEXT : CALL PUTNUM          ; subroutine 호출 (되돌아올 주소 0005H를 Stack에 PUSH)
        INC CL              ; CL += 1
        CMP CL, 10          
        JB NEXT             ; if CL < 10 ? NEXT
        MOV AH, 4CH         ; if CL >= 10 ? exit
        INT 21H

PUTNUM : MOV DL, CL 
    ADD DL, '0'             ; 0 -> '0'
    MOV AH, 2
    INT 21h
    RET                     ; Stack에서 POP하여 0005H를 IP값으로


CODE ENDS
    END


