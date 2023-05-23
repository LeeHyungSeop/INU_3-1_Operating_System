; 만약 'a'~'z', 'A'~'Z'를 출력하도록 바꾸면? -> 소문자, 대문자를 분리해야 한다. 아스키코드가 일렬로 되어있지 않으니까

CODE SEGMENT
    ASSUME CS: CODE
    MOV CL, 0

; ---- a ~ z ------
NEXT : CALL PUTNUM          ; subroutine 호출 (되돌아올 주소 0005H를 Stack에 PUSH)
        INC CL              ; CL += 1
        CMP CL, 26
        JB NEXT             ; if CL < 26 ? NEXT
        JMP LARGE

PUTNUM : MOV DL, CL 
    ADD DL, 'a'             ; 0 -> 'a'
    MOV AH, 2
    INT 21h
    RET                     ; Stack에서 POP하여 0005H를 IP값으로

; ---- A ~ Z ------
LARGE : 
    MOV CL, 0

    NEXT2 : CALL PUTNUM2          ; subroutine 호출 (되돌아올 주소 0005H를 Stack에 PUSH)
        INC CL              ; CL += 1
        CMP CL, 26
        JB NEXT2            ; if CL < 26 ? NEXT
        MOV AH, 4CH         ; if CL >= 26 ? exit
        INT 21H

    PUTNUM2 : MOV DL, CL 
        ADD DL, 'A'             ; 0 -> 'A'
        MOV AH, 2
        INT 21h
        RET                     ; Stack에서 POP하여 0005H를 IP값으로


CODE ENDS
    END


