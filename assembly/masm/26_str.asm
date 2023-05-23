; 문자열을 읽어서 출력하는 코드

main segment
    assume cs:main, ds:main

    mov ax, cs
    mov ds, ax 

    mov bx, offset L1 ; L1의 상대번지를 bx에 저장. L1을 읽을 것이기 때문

    mov dl, [bx] ; bx 주소에 있는 값을 dl에 저장
    mov ah, 2   ; dl에 있는 값을 출력 (A)
    int 21h     ; INT 21 - AH = 02th -> DL의 값 DISPLAY OUTPUT

    mov dl, [bx+1] ; bx+1 주소에 있는 값을 dl에 저장. (dw였다면 [bx+2]를 해야 할 것임.)
    mov ah, 2   ; dl에 있는 값을 출력 (B)
    int 21h     ; INT 21 - AH = 02th -> DL의 값 DISPLAY OUTPUT

    mov dl, [bx+2] ; bx+2 주소에 있는  dl에 저장
    mov ah, 2   ; dl에 있는 값을 출력 (C)
    int 21h     ; INT 21 - AH = 02th -> DL의 값 DISPLAY OUTPUT
    
    mov ah, 4ch ; program 종료
    int 21h

L1  db 'ABC' ; ABC라는 문자열을 byte 단위로 저장하겠다

main ends
    end