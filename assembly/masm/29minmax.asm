; 여러 숫자 중에서 max, min 둘 다 찾기

main segment
    assume cs:main , ds:main 

    MOV AX, CS
    MOV DS, AX

    MOV DI, OFFSET ARRAY
    MOV AX, [DI]        ; array의 첫번쨰 값을 읽어서 ax에 저장
    MOV MAX, AX      ; 우선 max에 대입 
    MOV MIN, AX      ; 우선 min에 대입
    
    MOV CX, 6       ; A1을 6번 loop 돌 것임
IS_MIN :
    MOV AX, [DI]
    CMP AX, MIN
    JAE IS_MAX
    MOV MIN, AX     ; ax가 더 작은 경우

IS_MAX :
    CMP AX, MAX
    JBE NEXT
    MOV max, ax

NEXT :     
    ADD DI, 2       ; word 단위니까 다음 숫자를 읽으려면 +2
    loop IS_MIN
    

    ; ----------------------------
    ; min = 2  출력 routine
    ; max = 15 출력 routine
    ; 작성해야 함
    MOV AX, min
    CALL PRINT_DEC_NUM

    MOV AH,2
    MOV DL,0DH
    INT 21h
    MOV DL,0AH
    INT 21h

    MOV AX, max
    CALL PRINT_DEC_NUM

    MOV AH, 4CH
    INT 21H
    
    PRINT_DEC_NUM : 
		MOV CX, 0
		MOV DX, 0
		LABEL1 :
			CMP AX, 0
			JE PRINT1	
			
			MOV BX, 10	
			DIV BX	            ; AX 또는 DX:AX 내용을 오퍼랜드로 나눔. 
								; 몫은 AL, AX 나머지는 AH, DX로 저장			
			PUSH DX			    ; 나머지 저장
			
			ADD CX, 1	
			
			MOV DX, 0   
			JMP LABEL1
		PRINT1 :
			CMP CX, 0
			JE EXIT
			
			POP DX              ; 10으로 나눈 나머지들을 pop
			ADD DX, '0'         ; ascill로 변환
			
			MOV AH, 02H         ; 출력
			INT 21H

			SUB CX, 1
			JMP PRINT1
	EXIT :		
        RET

    ; ----------------------------

    mov ah, 4ch
    int 21h         ; program 종료    


ARRAY   DW  15, 25, 8, 9, 6, 2
MAX     DW  ?
MIN     DW  ?

MAIN ENDS
    END