; register에 저장되어 있는 2bytes 16진수로 출력해 보기. 

CODE SEGMENT
    ASSUME CS:CODE, DS:CODE

    MOV AX,CODE
    MOV DS,AX

	MOV CX,0
	MOV DX,0

	PRINT_HEX_NUM : 
		MOV AX, 0
		MOV CX, 0
		MOV DX, 0
		MOV AX, HEX_NUM
		LABEL1 :
			CMP AX, 0
			JE PRINT1	
			
			MOV BX, 16	
			DIV BX	            ; AX 또는 DX:AX 내용을 오퍼랜드로 나눔. 
								; 몫은 AL, AX 나머지는 AH, DX로 저장			
			PUSH DX			    ; 나머지 저장
			
			ADD CX, 1	
			
			MOV DX, 0   
			JMP LABEL1
		PRINT1 :
			CMP CX, 0
			JE EXIT
			
			POP DX              ; 16으로 나눈 나머지들을 pop
            CMP DX, 9           ; 0~9까지는 '0' 더해서 출력해줘야 함
            JBE PRINT_ZERONINE
            CMP DX, 0AH
            JAE PRINT_AF

        PRINT_ZERONINE : 
            ADD DL, '0'
            mov ah, 02H
            INT 21H
			SUB CX, 1
			JMP PRINT1
        PRINT_AF : 
            SUB DL, 0AH
            ADD DL, 'A'
            mov ah,02h
            INT 21H
			SUB CX, 1
			JMP PRINT1

	EXIT :		
		MOV AH,4CH
		INT 21H

HEX_NUM DW 0F1A9H

CODE ENDS
    END