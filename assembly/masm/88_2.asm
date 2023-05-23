; (문제 2)
;     키보드에서 대 소문자 문자들을 계속 입력받으며 '소문자 x' 가 입력될때까지 그 갯수를 카운팅 하여 출력하는 PC 어셈블리 프로그램을 작성하시오.
;     예를들어    nocreditx 이라고 입력하면, 8 을 출력하면 됨. (x는 카운트 하지 않음)
;     입력은 아주 협조적이어서, 대소문자 이외에는 아무것도 입력하지 않는다고 가정하면 됨. (대소문자가 아닌 것에 대한 어떤 예외 처리도 필요없다는 것)
;     x 가 입력 종료 문자가 되는 것임.


MAIN SEGMENT
    ASSUME CS : MAIN, DS : MAIN
    
    MOV AX, CS
    MOV DS, AX 

    MOV CX, 0           ; CX Register는 count 변수로 생각

    INF : 
        MOV AH, 1       ; echo 있는 입력 받기 (AL에다가)
        INT 21H 

        CMP AL, 'x'
        JE PRINT       ; if 입력 == 'x' ? EXIT으로 JMP

        ADD CX, 1
        JMP INF

    PRINT : 
        MOV RESULT, CX
        JMP PRINT_DEC_NUM

    PRINT_DEC_NUM : 
            MOV AX, 0
            MOV CX, 0
            MOV DX, 0
            MOV AX, RESULT
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
        MOV AH, 4CH
        INT 21H

    RESULT DW ?

MAIN ENDS
    END


