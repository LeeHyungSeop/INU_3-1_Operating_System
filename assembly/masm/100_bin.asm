; register에 저장되어 있는 2bytes를 2진수로 출력해 보기. 

CODE SEGMENT
    ASSUME CS:CODE, DS:CODE

    MOV AX,CODE
    MOV DS,AX

    MOV AX, 0FF10H

    MOV CX, 16          ; 16번 loop 반복

    L1 :     
        SHL AX, 1       ; shift left 1bit -> 최상위 비트가 떨어져 나감.
        MOV DL, '0'     ; 떨어져 나온 bit는 carry가 발생함.
        JNC L2          ; jump not carry -> carry가 발생하지 않았으면 -> 0이었음 -> L2로 jump
        MOV DL, '1'     ; carry가 발생했으면, 1이었음 -> '1'을 출력하기 위해
    L2 : 
        PUSH AX         ; ax가 바뀌는 것을 막고자 ax를 보호하기 위해
        MOV AH, 2
        INT 21H
        POP AX          ; pop한 것을 ax에 넣겠다

        LOOP L1         

        MOV AX, 4c00h
        INT 21h

CODE ENDS
    END