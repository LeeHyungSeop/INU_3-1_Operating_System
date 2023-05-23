CODE SEGMENT
    ASSUME CS : CODE

    NEXT : MOV AH, 1            ; 1문자 입력
    INT 21H

    MOV DL, AL
    INC DL
    MOV AH, 2                   ; 1문자 출력
    INT 21H

    JMP NEXT                    ; 무조건 분기하여 다시 입력 받음

    MOV AH, 4CH                 
    INT 21H

CODE ENDS
END