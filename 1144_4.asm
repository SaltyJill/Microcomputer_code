CODE SEGMENT
          ASSUME CS:CODE
          ORG    1200H
    START:
          MOV    DX,8000H
    WAVE: MOV    AL,00H      ;起始位置
          OUT    DX,AL
    INC1: INC    AL          ;上升部分
          OUT    DX,AL
          CMP    AL,0FFH
          JNZ    INC1
    DEC1: DEC    AL          ;下降部分
          OUT    DX,AL
          CMP    AL,7FH
          JNZ    DEC1
          NOP                ;横线部分
          CALL   DELAY
          JMP    WAVE        ;循环
    DELAY:
          MOV    BX,180H
    X1:   DEC    BX
          JNZ    X1
          RET
CODE ENDS
END START