; 03_adc.asm  응용1
; VAR1(High Word)와 VAR2(Low Word)에 있는 32bit값과
; VAR3(High Word)와 VAR4(Low Word)에 있는 32bit값을
; 더해서 그 결과를 VAR1(High)과 VAR2(Low)에 저장하도록 응용해보자

CODE SEGMENT
    ASSUME CS : CODE, DS : DATA

    MOV AX, DATA
    MOV DS, AX

    MOV AX, VAR1
    MOV BX, VAR2
    MOV CX, VAR3
    MOV DX, VAR4

    ADD AX, BX          ; Carry Flag가 1로 set
    ADC CX, DX          ; Carry와 함께 덧셈

    MOV VAR1, AX
    MOV VAR2, CX

    MOV AX, VAR1
    CALL PRINT_HEX_NUM

    MOV AH,2
    MOV DL,0DH
    INT 21h
    MOV DL,0AH
    INT 21h

    MOV AX, VAR2
    CALL PRINT_HEX_NUM

    MOV AH, 4CH
    INT 21H

    PRINT_HEX_NUM : 
		MOV CX, 0
		MOV DX, 0
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
            RET

CODE ENDS

DATA SEGMENT    
    VAR1 DW 8000H       
    VAR2 DW 8123H           
    VAR3 DW 1223H           
    VAR4 DW 2000H

    ;   1223 8000 H
    ; + 2000 8123 H

    ; = 3224 0123 H

DATA ENDS
    END