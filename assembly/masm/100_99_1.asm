; 숫자 입력받아 구구단 출력하기 

CODE SEGMENT
    ASSUME CS:CODE, DS:CODE

    MOV AX,CODE
    MOV DS,AX

    MOV AH, 1       ; key input을 AL에 저장 (echo 있는 입력)
    INT 21H
    SUB AL, '0'
    MOV USER_INPUT, AL ; 입력 결과를 변수에 저장

    MOV AH, 2
    MOV DL, 0DH
    INT 21h
    MOV DL, 0AH
    INT 21h

    MOV AX, 1
    MOV BX, 1
    MOV CX, 9

    NEXT : 
        PUSH BX
        PUSH CX 

        ; USER INPUT 출력
        CALL PRINT_USER_INPUT
        ; * 출력
        CALL PRINT_MUL
        ; BL 출력
        MOV AH, 2   
        ADD BL, '0'    
        MOV DL, BL
        INT 21H
        ; = 출력
        CALL PRINT_EQUAL
        ; 곱셈 결과 출력
        MOV AL, USER_INPUT
        SUB BL, '0'
        MUL BL                    ; AX *= BL
        MOV RESULT, AL
        CALL PRINT_DEC_NUM
        ; 줄 바꿈 출력
        CALL PRINT_N

        POP CX
        POP BX
        ADD BX, 1
        LOOP NEXT     

    MOV AH,4CH
    INT 21H

    PRINT_USER_INPUT : 
        MOV DL, USER_INPUT
        ADD DL, '0'
        MOV AH, 2
        INT 21h
        RET
    PRINT_MUL : 
        MOV DL, MUL_SIGN
        MOV AH, 2
        INT 21h
        RET
    PRINT_EQUAL : 
        MOV DL, EQUAL_SIGN
        MOV AH, 2
        INT 21h
        RET
    PRINT_N : 
        MOV AH,2
        MOV DL,0DH
        INT 21h
        MOV DL,0AH
        INT 21h
        RET

	PRINT_DEC_NUM : 
		MOV AL, RESULT
        MOV BX, 0
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

RESULT DB ?
USER_INPUT DB ?
MUL_SIGN DB '*'
EQUAL_SIGN DB '='

CODE ENDS
    END