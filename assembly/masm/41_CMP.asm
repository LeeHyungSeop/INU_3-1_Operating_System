CODE SEGMENT
    ASSUME CS:CODE      ; DS: 가 없음 -> 이 code에서는 DATA를 쓰지 않는다
                        ;  + mov ds, cs -> 이러한 명령어가 아예 존재하지 않는다
                        ; mov ax, cs / mov ds , ax -> 일반 register를 통해서 mov하도록 해야 한다

NEXT : MOV AH, 1        ; keyboard input (AL에 저장됨)
       INT 21H

                        ; 만약 AL과 x(x or X)를 비교하여, 같으면 종료하고 싶다면?
       CMP al, 'x'        ; CMP al, x        (소문자 x면 종료)
       JE HERE          ; JE HERE
       CMP al, 'X'        ; CMP al, X 
       JE HERE          ; JE HERE           (대문자 X면 종료)


       MOV DL, AL       ; 입력받은 문자 AL을 DL에 저장
       INC DL           ; DL = DL + 1 (increase) -> +1해서 출력할 것임.
       MOV AH, 2        ; DL register에 있는 문자 하나를 출력해주는 interrupt
       INT 21H

       JMP NEXT         ; 분기 방법1 : JMP, NEXT라는 label로 가라
                        ; JB 등 -> 조건을 만족하면 JMP해라
       
HERE :                  
        MOV AH, 4CH      ; AX로 쓰지 않고, AH로 쓴 이유 : AL은 쓰지 않겠다 
        INT 21H          ; program 종료하고, 권한을 OS에 넘겨주는 

CODE ENDS
END