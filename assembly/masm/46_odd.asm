; ex. 홀수만 출력하라. 짝수는 출력하지 마라
; 1 3 5 7 9

CODE SEGMENT
    ASSUME CS : CODE

    MOV CX, 0

SUM10 : INC CX
        PUSH CX
        
        SHR CX, 1
        JC PRINT
        POP CX
        JMP SUM10                

        PRINT : 
            POP CX
            MOV DL, CL
            ADD DL, '0'
            MOV AH, 2                ; 홀수 출력
            INT 21H

        CMP CX, 8
        JBE SUM10       

        MOV AH, 4CH              ; Program 종료
        INT 21H

CODE ENDS
    END