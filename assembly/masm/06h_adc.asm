; 16bit memory값 VAR1에 16bit 값을 저장하고, 
; 상위 8bit 값과 하위 8bit 값을 더해서 
; 그 결과 8bit를 VAR2에 저장하도록 응용해보자
; (단, 여기서 Carry bit는 무시한다.)
; (단, 16bit 크기인 VAR1 memory 값을 8bit씩 따로 따로 읽은 뒤에, 그 값의 상위 8bit, 하위 8bit 값을 각각 더하는 방식으로 구현한다.)

CODE SEGMENT
    ASSUME CS : CODE, DS : DATA

    MOV AX, DATA
    MOV DS, AX

    MOV AX, VAR1

    ADD AH, AL          ; Carry 무시한 덧셈

    MOV VAR2, AH

    ; 출력하는 코드 추가
    
    MOV AH, 4CH
    INT 21H

CODE ENDS

DATA SEGMENT    
    VAR1 DW 1234H
    VAR2 DB ?
    ;   12 + 34 = 46H
DATA ENDS
    END