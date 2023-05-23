CODE SEGMENT
    ASSUME CS: CODE, DS:CODE

    MOV AX, CS
    MOV DS, AX

    MOV AL, 3FH ; 출력할 숫자
    CALL PUTAL  ; PUTAL 호출

    MOV AH, 4CH
    INT 21h

PUTAL :
    MOV BL, 10H 
    MUL BL          ; AX = 03F0H
    MOV LEVEL2, AH  ; 상위보존
    
    MOV AH, 0       ; AX=00F0H
    DIV BL          ; AL=0FH 
    MOV LEVEL1, AL  ; 하위보존
    MOV DL, LEVEL2
    CALL PUTHEX     ; PUTHEX 호출

    MOV DL, LEVEL1
    CALL PUTHEX     ; PUTHEX 호출
    RET             ; return

PUTHEX :
    CMP DL, 0AH 
    JAE HEX 
    
    ADD DL, '0'             ; 0~9면 '0~'9'로 바꿔야 함.
    JMP PRINT

HEX :
    ADD DL, 'A'-0AH         ; A~F면 'A'~'F'로 바꿔야 함

PRINT : 
    MOV AH, 2
    INT 21H 
    RET 

LEVEL1 DB ?
LEVEL2 DB ?

CODE ENDS
END