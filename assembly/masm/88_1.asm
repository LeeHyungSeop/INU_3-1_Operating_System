; (문제 1) 
;    키보드에서 입력받은 A~Z 의 문자에 따라 (단, 대소문자를 구분하지 않음),
;    각각 숫자 1~26이 화면에 출력되는 PC 어셈블리 프로그램을 작성하시오.
;    단, 이 프로그램은 무한 반복되게 해야 함.
;    예를들어, 소문자 z 나 대문자 Z를 입력하면 화면에 26 이 나타나면 됨.

MAIN SEGMENT
    ASSUME CS : MAIN, DS : MAIN
    
    MOV AX, CS
    MOV DS, AX 

    INF :     
        MOV AH, 1       ; echo 있는 입력 받기 (AL에다가)
        INT 21H 

        CMP AL, 'a'              ; 키보드 입력과 'a' 비교
        JAE STEP_SMALL           ; 입력 >= 'a'
        CMP AL, 'A'              ; 키보드 입력과 'A' 비교
        JAE STEP_LAR                 ; 키보드 입력 < 'A' 이면 그대로 출력
        JMP INF

        STEP_LAR:
            CMP AL, 'Z'
            JA INF               ; input > 'Z' --> 알파벳 아님
            SUB AL, 'A'         ; 'A' -> 0
            ADD AL, 1          ; 0 -> 1
            MOV DEC_NUM, AL
            JMP PRINT_DEC_NUM
        STEP_SMALL:
            CMP AL, 'z'
            JA INF             
            SUB AL, 'a'        ; 'a' -> 0
            ADD AL, 1          ; 0 -> 1
            MOV DEC_NUM, AL
            JMP PRINT_DEC_NUM

        PRINT_DEC_NUM : 
            MOV AX, 0
            MOV CX, 0
            MOV DX, 0
            MOV AL, DEC_NUM
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
                JE INF
                
                POP DX              ; 10으로 나눈 나머지들을 pop
                ADD DX, '0'         ; ascill로 변환
                
                MOV AH, 02H         ; 출력
                INT 21H

                SUB CX, 1
                JMP PRINT1

    DEC_NUM DB ?

MAIN ENDS
    END


