; 10진수 -> 2진수 변환 program
; 6CH -> 0110 1100

dosseg
.model small
.stack 100h  ; 여기서는 stack을 사용할 것이다. 이 program은 100보다 작을 것이기 때문에 100h부터 사용

.code 
main proc
    mov al, 6CH     ; 0110 1100(2)

    mov cx, 8       ; 8번 loop 반복

L1 :     
    SHL al, 1       ; shift left 1bit -> 최상위 비트가 떨어져 나감.
    mov dl, '0'     ; 떨어져 나온 bit는 carry가 발생함.
    jnc L2          ; jump not carry -> carry가 발생하지 않았으면 -> 0이었음 -> L2로 jump
    mov dl, '1'     ; carry가 발생했으면, 1이었음 -> '1'을 출력하기 위해
L2 : 
    push ax         ; ax가 바뀌는 것을 막고자 ax를 보호하기 위해
    mov ah, 2
    int 21h
    pop ax          ; pop한 것을 ax에 넣겠다

    loop L1         ; 

    mov ax, 4c00h
    int 21h
 
main endp
    end main