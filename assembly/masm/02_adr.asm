; 주소 지정 방식

CODE SEGMENT
    ASSUME CS : CODE , DS : CODE

CR EQU 0DH
LF EQU 00AH

    MOV AX, CODE
    MOV DS, AX 

    MOV BX, OFFSET BUFFER       ; BUFFER라는 data의 OFFSET주소값을 BX에 저장
    MOV SI, 2                   ; SI = 2

    MOV DL, [BX + SI]           ; DL = BUFFER라는 data의 OFFSET주소 + 2 = 'e'의 주소 + 2 = 'a'
    MOV AH, 2                   
    INT 21H                     ; DL 출력 : 'a'

    MOV DL, [BX + SI + 1]       ; DL = BUFFER라는 data의 OFFSET주소 + 2 + 1 = 'e'의 주소 + 3 = 'm'
    MOV AH, 2
    INT 21H

    MOV DL, CR                  ; Carrige Return (줄바꿈)
    MOV AH, 2
    INT 21H
    
    MOV DL, LF                  ; Line Feed (줄바꿈)
    MOV AH, 2
    INT 21H

    MOV DL, [BX + SI + 2]       ; DL = BUFFER라는 data의 OFFSET주소 + 2 + 2 = 'e'의 주소 + 4 = 'p'
    MOV AH, 2
    INT 21H

    MOV AH, 4CH                 ; program 종료
    INT 21H

BUFFER DB 'example.'

CODE ENDS
    END
