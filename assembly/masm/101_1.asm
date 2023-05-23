; (문제 1) 
;    다음의 순서대로 처리하는 PC 어셈블리 프로그램을 작성하시오.
;     (1) 키보드에서 십진수 5자리를 입력받는다. (예, 24896 , 무조건 5자리 숫자임)
;     (2) 이 숫자 5개를 모두 더한다. (예, 2+4+8+9+6 = 29)
;     (3) 이 숫자를 13보다 작거나 같아질때까지 13을 계속 뺀다. 혹은 13을 나눈 나머지를 구한다. ( 29-13-13 = 3, 혹은 29 % 13 = 3 )
;     (4) 이 숫자를 화면에 출력한다. (예, 3 )
;     (5) 위 (4)의 숫자 갯수만큼 화면에 'X' 를 출력한다. (예, XXX )
;     (6) 위 (1)번부터 과정을 무한 반복한다.

; 연속되는 문자를 입력받아 대문자/소문자 개수 구하기

.MODEL SMALL
.STACK 100H

.DATA
    maxLen equ 5                
    newLine DB 0DH, 0AH, '$'    
    mySum DW ?
    CHAR DB 'X'

.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX        
          
    INF : 
        MOV mySum, 0
        MOV CX, maxLen 

        READ_LOOP:
            PUSH CX
            MOV AH, 01H                 
            INT 21h                     
            SUB AL, '0'

            ; mySum에 더해줌
            CALL ACCSUM
            
            POP CX
            HERE : 
                LOOP READ_LOOP              
        
        MOV AX, mySum
        JMP PRINT_DEC_NUM


    ACCSUM : 
        ADD AX, mySum
        MOV mySum, AX
        RET

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
            JMP INF
            
            POP DX              ; 10으로 나눈 나머지들을 pop
            ADD DX, '0'         ; ascill로 변환
            
            MOV AH, 02H         ; 출력
            INT 21H

            SUB CX, 1
            JMP PRINT1
            
    MAIN ENDP
END MAIN
