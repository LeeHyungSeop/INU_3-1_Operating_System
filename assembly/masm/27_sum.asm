; 26_str.asm과는 다른 template을 이용하여 단순 연산 프로그램을 작성

.model small ; 예전에 program을 minimal하게 만들기 위해 사용했던 방법.
.stack 100h  ; "100h 부터 stack을 사용하겠다" 라는 뜻. 지금은 쓰지 않을 것.

.data        ; 여기서부터 data segment이다.
a   db  2
b   db  5
sum db  ?


.code       ; 여기서부터 code segment이다.
main proc
    mov ax, @data   ; @data : data segment를 말함
    mov ds, ax

    mov al, a       ; al = a 
    add al, b       ; al = al + b 
    mov sum, al     ; sum = al
    
    add al, '0'     ; al = '0' + 7 -> al의 숫자 7을 문자 '7'로 바꾸는 과정
    mov dl, al      ; dl = '7'
    mov ah, 2   ; dl에 있는 값을 출력 ('7')
    int 21h     ; INT 21 - AH = 02th -> DL의 값 DISPLAY OUTPUT

    mov ax, 4c00h   ; program 종료
    int 21h     
main endp   ; end procedure
    end main    ; "main에서 시작하겠다"