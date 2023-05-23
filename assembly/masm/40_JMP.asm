CODE SEGMENT
    ASSUME CS:CODE      ; DS: 가 없음 -> 이 code에서는 DATA를 쓰지 않는다
                        ;  + mov ds, cs -> 이러한 명령어가 아예 존재하지 않는다
                        ; mov ax, cs / mov ds , ax -> 일반 register를 통해서 mov하도록 해야 한다

NEXT : MOV AH, 1        ; keyboard input
       INT 21H

       MOV DL, AL       ; 
       INC DL           ; DL = DL + 1 (increase)
       MOV AH, 2        ; DL register에 있는 문자 하나를 출력해주는 interrupt
       INT 21H

       JMP NEXT         ; 분기 방법1 : JMP, NEXT라는 label로 가라
                        ; JB 등 -> 조건을 만족하면 JMP해라
       
       MOV AH, 4CH      ; AX로 쓰지 않고, AH로 쓴 이유 : AL은 쓰지 않겠다 
       INT 21H          ; program 종료하고, 권한을 OS에 넘겨주는 

CODE ENDS
END