STAK    SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK    ENDS

DATA    SEGMENT PARA 'DATA'
YEDEKOFFSET  DW 0
YEDEKSEGMENT DW 0
DATA    ENDS

CODE    SEGMENT PARA 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STAK
	
ARTIR PROC FAR
	PUSH BP
	MOV BP, SP
	INC AX
	POP BP
	IRET
ARTIR ENDP
	
	
START PROC FAR
	MOV AX, DATA
	MOV DS, AX
	
	MOV AL, 00110100B	
	OUT 7EH, AL
	
	MOV AL, 01110100B	
	OUT 7EH, AL
	
	MOV AX, 12000
	OUT 78H, AL
	MOV AL, AH
	OUT 78H, AL
	
	;2250 15sn
	;5500 30sn
	;9000 1dk
	MOV AX, 2250
	OUT 7AH, AL
	MOV AL, AH
	OUT 7AH, AL
	
	XOR AX, AX
	MOV ES, AX
	MOV AL, 40H 	;tip 40 interrupt
	MOV AH, 4
	MUL AH		;interrupt vektör tablosunda 4x40 tan 160. adrese yazıldı
	MOV BX, AX
	LEA AX, ARTIR	;arttırın adresi ax e alındı
	MOV WORD PTR ES:[BX], AX	;offset 160a yazılacak
	MOV AX, CS
	MOV WORD PTR ES:[BX+2], AX	;162 ye segmentler yazıldı tip 40 olarak
	
	MOV AL, 13H
	OUT 60H, AL
	MOV AL, 40H
	OUT 62H, AL
	MOV AL, 03H
	OUT 62H, AL
	STI
	XOR AX, AX
	
ENDLESS:
        JMP ENDLESS
	
	RET
START ENDP
CODE    ENDS
        END START