CODE SEGMENT    
    ASSUME CS:CODE, DS : CODE
    ORG 100H

START : 
    MOV AX, CS 
    MOV DS, AX 

    MOV BX, 0

    MOV DX, TABLE[BX]
    MOV AH, 9H
    INT 21H             ; print string

STOP : 
    MOV AX, 4C00H
    INT 21H             ; QUIT WITH EXIT CODE (EXIT)

M1 DB 'msg 1', '$'
M2 DB ' msg 2', '$'
M3 DB '  msg 3', '$'
M4 DB '   msg 4', '$'
M5 DB '    msg 5', '$'

TABLE DW OFFSET M1, OFFSET M2, OFFSET M3, OFFSET M4, OFFSET M5

CODE ENDS
    END START
