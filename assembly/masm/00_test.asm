; (문제 1) 
;    키보드에서 입력받은 A~Z 의 문자에 따라 (단, 대소문자를 구분하지 않음),
;    각각 숫자 1~26이 화면에 출력되는 PC 어셈블리 프로그램을 작성하시오.
;    단, 이 프로그램은 무한 반복되게 해야 함.
;    예를들어, 소문자 Z 나 대문자 Z를 입력하면 화면에 26 이 나타나면 됨.

CODE SEGMENT
    ASSUME CS : CODE, DS : CODE

    MOV AX, CS
    MOV DS, AX 

    MOV DX, 20
    ADD AX, 11

    mov ah, 4ch
    int 21h 

CODE ENDS
    END 