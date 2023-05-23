; 소문자를 대문자로 바꾸는 코드
; 대문자를 소문자로 바꾸는 코드로 바꾸면?

.model small
.stack 100h
.data  
    prompt db 'enter a lower case letter : $'
    msg db 0Dh, 0Ah, 'in upper case it is : '   
    char db ?, '$'
.code 
main proc
    mov ax, @data                               ; get data segement
    mov ds, ax

    mov dx, offset prompt                       ; prompt의 시작주소를 dx에 저장
    mov ah, 9                                   ;  'enter a lower case letter : '를 출력
    int 21h                                     ; 

    mov ah, 1                                   ; echo 있는 입력 받기 (AL에다가)
    int 21h                                     

    sub al, 20h                                 ; converts to upper case (16진수 20 -> 10진수 32 -> 'a'-32 = 'A')
    mov char, al                                ; store char

    mov dx, offset msg                          ; msg의 시작주소를 dx에 저장
    mov ah, 9
    int 21h                                     ; final message display 

    mov ah, 4ch
    int 21h 

main endp
end main