; Scrolling N lines by input

.model small
.stack 100H
.code 
main proc

    MOV DX, offset mesg
    MOV AH, 9H          ; print string
    INT 21H 

    MOV AH, 7
    INT 21H             ; key input
    SUB AL, '0'

    MOV BH, 7           ; BH = attribute to be used on blank line
    MOV CX, 0000H       ; Scroll(CH, CL) = (DH, DL) (y, x)
    MOV DX, 194Fh       ; = Scroll(0H, 0H) - (19H, 4FH)
    MOV AH, 06H         ; AL = number of lines to scroll
    INT 10H             ; make a box blank and scroll it up
    
            ; INT 10 - AH = 06h VIDEO - SCROLL PAGE UP
            ; AL = number of lines to scroll window (0 = blank whole window)
            ; BH = attributes to be used on blanked lines
            ; CH,CL = row,column of upper left corner of window to scroll 
            ; DH,DL = row,column of lower right corner of window

STOP : 
    MOV AX, 4C00H
    INT 21H
mesg DB "Line Number for scrolling : $"

main endp
    end main