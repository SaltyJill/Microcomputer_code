CODE SEGMENT
          ASSUME CS:CODE
          ORG    1200H
    START:
          MOV    DX,8000H    ;74LS244作输入口的片选地址，读取开关s1和s2的状态
          IN     AL,DX
          TEST   AL,01H
          JNZ    S1
          TEST   AL,02H
          JNZ    S2
          MOV    DX,9000H    ;无操作状态下灯全灭
          MOV    AL,0FFH
          OUT    DX,AL
          JMP    START
    
    S1:   TEST   AL,02H      ;判断s1和s2同时按下的情况
          JNZ    S3

          MOV    DX,9000H    ;只有s1按下的情况
          MOV    AL,0BBH
          OUT    DX,AL
          JMP    START

    S2:   TEST   AL,01H
          JNZ    S3

          MOV    DX,9000H    ;只有s2按下的情况
          MOV    AL,0BAH
          OUT    DX,AL
          JMP    START
    
    S3:   MOV    DX,9000H    ;s1和s2同时按下的情况
          MOV    AL,00H
          OUT    DX,AL
          JMP    START
CODE ENDS
END START