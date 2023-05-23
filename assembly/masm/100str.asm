; 연속되는 문자를 입력받아 대문자/소문자 개수 구하기

.MODEL SMALL
.STACK 100H

.DATA
    buffer DB 100 DUP ('$')     ; 입력된 문자열을 저장할 버퍼
    maxLen equ 99               ; 버퍼의 최대 길이
    newLine DB 0DH, 0AH, '$'    ; 개행 문자열
    smallCnt DB 0
    largeCnt DB 0

.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX          
        
        MOV CX, maxLen ; 반복 횟수 설정
        
        MOV DI, 0 ; 문자열 버퍼의 인덱스
        
    READ_LOOP:
        MOV AH, 01H                 ; 키 입력 함수 호출
        INT 21h                     ; 키 입력 대기
        
        CMP AL, 0DH                 ; Enter 키 확인
        JE END_READ                 ; Enter 키일 경우 입력 종료
        
        MOV [buffer+DI], AL         ; 읽은 문자를 버퍼에 저장
        INC DI                      ; 다음 문자의 인덱스로 이동

        ; 대소문자 판별
        CMP AL, 'a'              ; 키보드 입력과 'z' 비교
        JAE STEP_SMALL           ; 키보드 입력 > 'z' 이면 그대로 출력
        CMP AL, 'A'              ; 키보드 입력과 'A' 비교
        JAE STEP_LAR             ; 키보드 입력 < 'A' 이면 그대로 출력
        
        HERE : 
            LOOP READ_LOOP              ; CX 레지스터가 0이 될 때까지 반복
        
    END_READ:
        MOV [buffer+DI], '$'        ; 문자열의 끝을 나타내는 '$' 추가
        
        MOV DX, OFFSET buffer       ; 입력된 문자열의 시작 주소를 DX에 설정
        MOV AH, 09h                 ; 문자열 출력 함수 호출
        INT 21h                     ; 문자열 출력

        MOV AH, 09h                 ; 문자열 출력 함수 호출
        MOV DX, OFFSET newLine      ; 개행 문자열 출력
        INT 21h                     ; 문자열 출력

        ; 소문자 개수 출력
        MOV AH, 0
        MOV AL, smallCnt
        CALL PRINT_DEC_NUM

        MOV AH, 09h                 ; 문자열 출력 함수 호출
        MOV DX, OFFSET newLine      ; 개행 문자열 출력
        INT 21h                     ; 문자열 출력

        ; 대문자 개수 출력
        MOV AH, 0
        MOV AL, largeCnt
        CALL PRINT_DEC_NUM
        
        MOV AH, 4Ch 
        INT 21h                     ; 프로그램 종료

    
        STEP_LAR : 
            CMP AL, 'Z'
            JBE COUNT_LAR
        STEP_SMALL : 
            CMP AL, 'z'
            JBE COUNT_SMALL

        COUNT_SMALL :
            MOV BL, smallCnt
            ADD BL, 1
            MOV smallCnt, BL
            JMP HERE
        COUNT_LAR :
            MOV BL, largeCnt
            ADD BL, 1
            MOV largeCnt, BL
            JMP HERE

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
            
    MAIN ENDP
END MAIN
