; 숫자 3개 중 작은 것을 찾아내는 프로그램 

main segment
    assume cs:main, ds:main

    mov ax, cs
    mov ds, ax 

    mov si, offset val  ; si = val의 시작 주소

    mov al, [si]        ; al = 7

    add si, 1           ; si = val의 시작 주소 + 1
    cmp al, [si]        ; 7과 3 비교
    jbe L1              ; al(7)이 blew or equal? == 작거나 같으면? L1으로 jump
    mov al, [si]        ; 그렇지 않으면 al에 [si](3) 대입

L1 : cmp al, [si+1]
     jbe L2
     mov al, [si+1]

L2 : mov small, al
     mov dl, al
     add dl, '0'

     mov ah, 2
     int 21h        ; 가장 작은 값 출력

     mov ah, 4ch
     int 21h



small db ?
val   db 3, 7, 4

main ends
    end