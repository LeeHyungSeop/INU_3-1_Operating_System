; 만약 'a'~'z'를 출력하도록 바꾸면?

CODE SEGMENT
    ASSUME CS: CODE
    MOV CL, 0

NEXT : CALL PUTNUM          ; subroutine 호출 (되돌아올 주소 0005H를 Stack에 PUSH)
        INC CL              ; CL += 1
        CMP CL, 26
        JB NEXT             ; if CL < 26 ? NEXT
        MOV AH, 4CH         ; if CL >= 26 ? exit
        INT 21H

PUTNUM : MOV DL, CL 
    ADD DL, 'a'             ; 0 -> 'a'
    MOV AH, 2
    INT 21h
    RET                     ; Stack에서 POP하여 0005H를 IP값으로


CODE ENDS
    END


