CODE SEGMENT
            ASSUME CS:CODE
            ORG    1200H
    COUNT0  EQU    40H
    COUNT1  EQU    41H
    COUNT2  EQU    42H
    COUNTCN EQU    43H
    START:  
            MOV    DX,COUNTCN
            MOV    AL,00110100B    ;方式控制字,计数器0,16位计数,方式1,二进制计数
            OUT    DX,AL
            MOV    DX,COUNT0       ;计数器0地址
            MOV    AL,00100000B    ;赋初值，0320低八位
            OUT    DX,AL
            MOV    AL,00000011B    ;高八位
            OUT    DX,AL
            MOV    DX,COUNTCN
            MOV    AL,01110110B    ;方式控制字,计数器1,方式3,其余同计数器0
            OUT    DX,AL
            MOV    DX,COUNT1       ;计数器1地址
            MOV    AL,01110001B    ;赋初值，0271低八位
            OUT    DX,AL
            MOV    AL,00000010B    ;高八位
            OUT    DX,AL
            JMP    $
CODE ENDS
END START