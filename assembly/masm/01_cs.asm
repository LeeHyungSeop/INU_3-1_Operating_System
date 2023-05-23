; code segment만 존재하는 assembly program

CODE SEGMENT
    ASSUME CS : CODE

    MOV AH, 12H
    MOV AL, 34H
    ADD AH, AL

    MOV AH, 4CH
    INT 21H

CODE ENDS  
    END    