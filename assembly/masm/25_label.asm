; segment를 main 하나로 두지 않고, 나누면 어떻게 작성할까?
; code segment를 main, data segment를 data로 나눠보자.

main segment
    assume cs:main, ds:data     ; cs와 ds 나누기

start : mov ax, data
        mov ds, ax 

        mov al, A   
        add al, B    
        mov sum, al 

        mov ax, 4c00h
        int 21h 
main ends

data segment
    A db 0ffh
    B db 1
    SUM db ?
data ends

    end start