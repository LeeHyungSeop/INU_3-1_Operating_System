.MODEL SMALL
.STACK 100H
.DATA
; printable range [0 65535]
d1 dw 0faa1h
.CODE
MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX   
    
    ;load the value stored
    ; in variable d1
    mov ax,d1      
    
    ;print the value
    CALL PRINT     
    
    ;interrupt to exit              
    MOV AH,4CH
    INT 21H

MAIN ENDP
PRINT PROC          
    
    ;initialize count
    mov cx,0
    mov dx,0
    label1:
        ; if ax is zero
        cmp ax,0
        je printorder     
        
        ;initialize bx to 10
        mov bx,16  
        
        ; extract the last digit
        div bx                 

        ; div == ax / bx 
        ; ax /= bx
        ; dx = ax % bx

        ;push it in the stack
        push dx             
        
        ;increment the count
        inc cx             
        
        ;set dx to 0
        xor dx,dx
        ; dx는 자신과 같으니, xor dx, dx == always zero.
        jmp label1

    printorder:
        ; cx == stack size
        ;check if count
        ;is greater than zero
        cmp cx,0
        je exit
        pop dx
        cmp dx, 10
        jb print1
        jmp printh
    print1:
        add dx,'0'
        mov ah,02h
        int 21h
        dec cx
        jmp printorder
    printh:
        add dx,'A'-10
        mov ah,02h
        int 21h
        dec cx
        jmp printorder

exit:
ret
PRINT ENDP
END MAIN