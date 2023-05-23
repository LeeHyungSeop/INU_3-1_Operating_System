; LOOP : CX값을 사용하여 반복

CODE SEGMENT
    ASSUME CS : CODE

    MOV AX, 0
    MOV BX, '0'
    MOV CX, 10

    NEXT : 

            MOV AH, 2       ; 출력
            MOV DL, BL
            INT 21H

           INC BX
           LOOP NEXT     

    MOV AH, 4CH              ; Program 종료
    INT 21H

CODE ENDS
    END