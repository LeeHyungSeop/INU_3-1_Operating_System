; register에 저장되어 있는 10진수 10진수로 출력해 보기. 

CODE SEGMENT
    ASSUME CS:CODE, DS:CODE

    MOV AX,CODE
    MOV DS,AX

	MOV CX,0
	MOV DX,0

	PRINT_DEC_NUM : 
		MOV AX, 0
		MOV CX, 0
		MOV DX, 0
		MOV AX, DEC_NUM
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
		MOV AH,4CH
		INT 21H

DEC_NUM DW 1234

CODE ENDS
    END