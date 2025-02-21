CODE SEGMENT
          ASSUME CS:CODE
          ORG    1200H
    START:
          MOV    DX,0FF2BH
          MOV    AL,80H
          OUT    DX,AL        ;设置8255方式，A口出

    L1:   MOV    DX, 8000H    ;ADC0809端口地址
          MOV    AL,0         ;选择通道0
          OUT    DX,AL        ;发CS和WR信号并送通道地址

          MOV    AH,0FFH
    DELAY:DEC    AH
          JNZ    DELAY        ;延时

          MOV    DX,8000H
          IN     AL,DX        ;读0809转换结果
          NOT    AL
          
          MOV    DX,0FF28H
          OUT    DX,AL        ;通过8253 A口控制LED
          JMP    L1           ;循环采样A/D转换的结果
CODE ENDS
END START
