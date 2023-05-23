; 구구단 한 단 출력하기

CODE SEGMENT
    ASSUME CS:CODE, DS:CODE

    MOV AX,CODE
    MOV DS,AX

    MOV SI,10

    ;string의 offset 
    MOV DI,OFFSET STRING

    MOV AL,NUM
    ADD AL,'0'
    MOV [DI],AL

    MOV CX,9
    MOV BL,1

LOOP1:

    ; 2 * 1 =  까지 출력 
    MOV AL,NUM

    ADD BL,'0'
    MOV [DI+4],BL
    SUB BL,'0'

    MOV DX,OFFSET STRING

    MOV AH,9
    INT 21H

    MUL BL
    INC BL
    
    PUSH CX
    MOV CX,0
    CALL PRINT_ANSWER
    POP CX

    CALL NEXTLINE
    LOOP LOOP1

    MOV AH,4ch
    INT 21H


PRINT_ANSWER:
    MOV DX,0
    DIV SI
    PUSH DX
    INC CX

    CMP AX,0
    JNE PRINT_ANSWER

LOOP2:
    POP DX
    ADD DL,'0'
    MOV AH,2
    INT 21H

    LOOP LOOP2



    RET


NEXTLINE:
    PUSH DX
    PUSH AX

    MOV AH,2
    MOV DL,0DH
    INT 21h
    MOV DL,0AH
    INT 21h
    
    POP AX
    POP DX

    RET


    NUM DB 7
    STRING DB ?,' * ',?, ' = ','$'
    


CODE ENDS
    END