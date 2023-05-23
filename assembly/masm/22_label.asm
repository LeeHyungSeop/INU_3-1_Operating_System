; 잘못된 방법

main segment 

    assume cs : main, ds : main 

    ; Data 영역을 앞에 놓고 아무런 조치가 없음 --> Data를 Code로 해석해버림 --> 엉뚱한 실행..
    A DW 2
    B DW 5
    SUM DW ?

START :
    MOV AX, A   
    ADD AX, B 
    MOV SUM, AX 

    MOV AX, 4C00H
    INT 21H

main ends 
    end 