CODE SEGMENT
              ASSUME CS:CODE
    INTPORT1  EQU    0060H
    INTPORT2  EQU    0061H
    INTQ3     EQU    INTREEUP3
    INTCNT    DB     ?
              ORG    1200H

    START:    CLD
              MOV    DX,0FF2BH
              MOV    AL,80H         ;设置8255方式字，A口出
              OUT    DX,AL
              CALL   WRINTVER       ;WRITEINTRRUPT
              MOV    AL,13H         ;ICW1=00010011B,边沿触发、单8259、需ICW4
              MOV    DX,INTPORT1
              OUT    DX,AL
              MOV    AL,08H         ;ICW2=00001000B,IR3 进入则中断号 =0BH
              MOV    DX,INTPORT2
              OUT    DX,AL
              MOV    AL,09H         ;ICW4=00001001B,非特殊全嵌套方式、缓冲/从、正常EOI
              OUT    DX,AL
              MOV    AL,0EFH        ;OCW1=11101111B
              OUT    DX,AL
              MOV    INTCNT,01H     ;延时
              STI

    WATING:   
              MOV    DX,0FF28H      ;主程序绿灯亮（低四位为0则绿灯亮，高四位为1故红灯灭）
              MOV    AL,0FCH
              OUT    DX,AL
              JMP    WATING

    WRINTVER: 
              MOV    AX,0H
              MOV    ES,AX
              MOV    DI,0030H       ;中断向量地址2CH=0CH*4
              LEA    AX,INTQ3
              STOSW                 ;送偏移地址
              MOV    AX,0000h
              STOSW                 ;送段地址
              RET

    INTREEUP3:CLI                   ;中断服务子程序开始
              PUSH   AX
              PUSH   DX
              MOV    DX,0FF28H      ;中断服务子程序执行红灯亮
              MOV    AL,5FH         ;低四位为1则绿灯灭，高四位为0故红灯亮
              OUT    DX,AL
              CALL   DELAY1S

              MOV    AL,20H         ;OCW2=001 00 000B;非特殊EOI命令，结束命令，用于完全嵌套方式的中断结束
              MOV    DX,INTPORT1
              OUT    DX,AL
              POP    DX
              POP    AX
              STI                   ;开系统中断
              IRET

    DELAY1S:  
              MOV    CX,0FFFFH
              MOV    BX,5
    L:        DEC    CX
              JNZ    L
              DEC    BX
              JNZ    L
              RET
CODE ENDS
END START
