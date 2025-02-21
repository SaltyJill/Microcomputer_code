CODE SEGMENT
            ASSUME CS:CODE
            ORG    1000H        ; 代码从内存地址1000H开始
    INTCNT  DB     '?'          ; 中断计数器，用于记录中断次数对应的红灯模式
    START:  
            MOV    INTCNT,0FH   ; 初始化INTCNT为0FH（00001111B，初始红灯模式）
            MOV    DX,0FF2BH    ; 8255控制寄存器端口
            MOV    AL,80H       ; 设置8255为模式0，所有端口为输出
            OUT    DX,AL

            CALL   IVT          ; 调用中断向量表设置子程序

            ; 初始化8259中断控制器
            MOV    DX,0060H     ; 8259端口地址（ICW1）
            MOV    AL,13H       ; 边沿触发、单片8259、需要ICW4
            OUT    DX,AL

            MOV    DX,0061H     ; 8259端口地址（ICW2）
            MOV    AL,0CH       ; 中断类型号基址为08H（IR0对应08H）
            OUT    DX,AL

            MOV    AL,09H       ; ICW4：正常EOI、非缓冲模式
            OUT    DX,AL

            MOV    AL,11101111B ; OCW1：允许IR4中断（第4位=0）
            OUT    DX,AL

            STI                 ; 开中断

    WAITING:MOV    DX,0FF28H    ; 主循环：点亮绿灯（假设端口FF28H控制LED）
            MOV    AL,0F0H      ; 11110000B（高4位绿灯亮）
            OUT    DX,AL
            JMP    WAITING     ; 持续循环

    ;--- 中断向量表设置子程序（IVT）--- 
    IVT:    MOV    AX,00H       ; 中断向量表段地址=0000H
            MOV    DS,AX
            MOV    BX,30H       ; IR4中断号=0CH，向量表偏移=0CH*4=30H
            MOV    AX,OFFSET ISUB ; 设置中断服务程序偏移地址
            MOV    [BX],AX
            MOV    AX,SEG ISUB  ; 设置中断服务程序段地址
            MOV    [BX+2],AX
            RET

    ;--- 中断服务程序（ISUB）---
    ISUB:   CLI                 ; 关中断
            PUSH   AX           ; 保存寄存器
            PUSH   DX
            MOV    DX,0FF28H    ; LED控制端口
            MOV    AL,INTCNT    ; 加载当前红灯模式
            OUT    DX,AL        ; 输出到LED（例如0FH=00001111B点亮4个红灯）
            CALL   DELAY       ; 延时保持红灯可见

            ; 根据当前INTCNT值切换到下一个红灯模式
            CMP    INTCNT,0BFH  ; 10111111B（模式1）
            JZ     I2
            CMP    INTCNT,3FH   ; 00111111B（模式2）
            JZ     I3
            CMP    INTCNT,2FH   ; 00101111B（模式3）
            JZ     I4
            CMP    INTCNT,0FH   ; 00001111B（模式4）
            JZ     I1

    I2:     MOV    INTCNT,3FH   ; 切换到模式2
            JMP    INTRE2
    I3:     MOV    INTCNT,2FH   ; 切换到模式3
            JMP    INTRE2
    I4:     MOV    INTCNT,0FH   ; 切换到模式4
            JMP    INTRE2
    I1:     MOV    INTCNT,0BFH  ; 切换到模式1

    ;--- 中断结束处理 ---
    INTRE2: MOV    DX,0060H     ; 8259端口地址（OCW2）
            MOV    AL,20H       ; 发送EOI（End of Interrupt）命令
            OUT    DX,AL
            POP    DX           ; 恢复寄存器
            POP    AX
            STI                 ; 开中断
            IRET               ; 中断返回

    ;--- 延时子程序（DELAY）---
    DELAY:  MOV    BL,5FH       ; 外层循环次数
    DELAY1: MOV    AX,0FFFH     ; 内层循环次数
    DELAY2: DEC    AX
            JNZ    DELAY2       ; 内层循环
            DEC    BL
            JNZ    DELAY1       ; 外层循环
            RET

CODE ENDS
        END START