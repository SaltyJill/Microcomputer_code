CODE SEGMENT
           ASSUME CS:CODE
           ORG    1200H
    PORTA  EQU    0FF28H
    PORTB  EQU    0FF29H
    PORTC  EQU    0FF2AH
    PORTCN EQU    0FF2BH

    START: 
           MOV    DX,PORTCN    ;写初始化8255控制字，三个端口工作在方式0且处于输出状态
           MOV    AL,80H
           OUT    DX,AL

           MOV    DX,PORTB     ;黄灯全灭
           MOV    AL,0FFH
           OUT    DX,AL

           MOV    CX,4H        ;红灯闪烁计时
    RED:   
           MOV    DX,PORTC     ;四路红灯亮
           MOV    AL,0F0H
           OUT    DX,AL
           CALL   delayF       ;闪烁延时
           MOV    DX,PORTC     ;四路红灯灭
           MOV    AL,0FFH
           OUT    DX,AL
           CALL   delayF       ;闪烁延时
           DEC    CX           ;循环4次
           JNZ    RED
        
           MOV    DX,PORTC     ;红灯熄灭
           MOV    AL,0F0H
           OUT    DX,AL
           CALL   DELAY1       ;等待延时

    loop0: MOV    DX,PORTC     ;1,3路口绿灯亮，2,4红灯亮
           MOV    AL,0A5H
           OUT    DX,AL
           CALL   DELAY2
           MOV    DX,PORTC     ;1,3路口绿灯灭，2,4红灯亮
           MOV    AL,0F5H
           OUT    DX,AL

           MOV    CX,6H
    YEL1:  
           MOV    DX,PORTB     ;1,3路口黄灯亮，2,4黄灯灭
           MOV    AL,0AFH
           OUT    DX,AL
           CALL   delayF
           MOV    DX,PORTB     ;1,3路口黄灯灭，2,4黄灯灭
           MOV    AL,0FFH
           OUT    DX,AL
           CALL   delayF
           DEC    CX
           JNZ    YEL1

           MOV    DX,PORTC     ;四路红灯亮,绿灯全灭
           MOV    AL,0F0H
           OUT    DX,AL

           CALL   delayF       ;点亮确认

           MOV    DX,PORTC
           MOV    AL,5AH       ;2,4绿灯亮，1,3红灯亮
           OUT    DX,AL

           CALL   DELAY3

           MOV    DX,PORTC     ;2,4红灯亮，1,3绿灯亮
           MOV    AL,0FAH
           OUT    DX,AL

           MOV    CX,8
    YEL2:  
           MOV    DX,PORTB     ;黄灯闪烁8次
           MOV    AL,5FH
           OUT    DX,AL
           CALL   delayF
           MOV    DX,PORTB
           MOV    AL,0FFH
           OUT    DX,AL
           CALL   delayF
           DEC    CX
           JNZ    YEL2

           MOV    DX, PORTC    ;四路红灯
           MOV    AL, 0F0H
           OUT    DX, AL
           CALL   delayF

           JMP    loop0

    DELAY1:
           MOV    AX,20
           MOV    BX,0H
    x:     
           DEC    BX
           JNZ    x
           DEC    AX
           JNZ    x
           RET
    DELAY2:
           MOV    AX,1H
           MOV    BX,0H
    y:     
           DEC    BX
           JNZ    y
           DEC    AX
           JNZ    y
           RET
    DELAY3:
           MOV    AX,5
           MOV    BX,0H
    z:     
           DEC    BX
           JNZ    z
           DEC    AX
           JNZ    z
           RET
    delayF:
    F:     MOV    BX,8000H
           DEC    BX
           JNZ    F
           RET
CODE ENDS
END START