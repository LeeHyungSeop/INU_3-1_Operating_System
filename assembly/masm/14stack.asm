CODE SEGMENT
    ASSUME CS : CODE

    MOV AX, 1234H
    MOV BX, 5678H           ; SP = 0

    PUSH AX                 ; SP = FFFEH
    PUSH BX                 ; SP = FFFCH
    PUSHF                   ; SP = FFFAH

    MOV AX, 2468H           
    MOV BX, 2468H
    SUB AX, BX

    POPF                    ; SP = FFFCH
    POP BX                  ; SP = FFFEH
    POP AX                  ; SP = 0

    MOV AH, 4CH
    INT 21h

CODE ENDS
    END