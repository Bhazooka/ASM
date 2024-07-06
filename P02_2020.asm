.386
.MODEL FLAT
.STACK 4096

INCLUDE io.inc       ; OutputStr & InputStr are functions defined in the io.inc


ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA

    PROMPT0	BYTE 	"This program will run until you enter 0 for g",10,0
            ; 10, is the newline
    PROMPT1	BYTE	"Please enter g:",0
    PROMPT2 BYTE	"Please enter p:",0
    PROMPT3 BYTE 	"Please enter a:",0
    PROMPT4 BYTE	"Please enter b:",0
    ANSWER	BYTE	"The ephemeral key k=",0
    NEWLINE	BYTE	10,0

    p DWORD ?
    g DWORD ?
    a DWORD ?
    b DWORD ?
    k DWORD ?


.CODE
_start: 

        ; ________________Capturing the value for g________________________
    INVOKE OutputStr, ADDR PROMPT0      ; Displays text stored in PROMPT0 and 10, (puts cursor on newline)
    INVOKE OutputStr, ADDR PROMPT1      ; Displays text stored in PROMPT1
    INVOKE InputInt                     ; Waits for input and stores it in EAX register
    mov g, eax                          ; Move value from EAX register into g

        ; ____________if statement_______________
    cmp g, 0            ; if g = 0
    je endProg          ; jump to endProg Procedure


        ; ________________Capturing rest of inputs p, a, b________________________
    INVOKE OutputStr, ADDR PROMPT2
    INVOKE InputInt
    mov p, eax

    INVOKE OutputStr, ADDR PROMPT3
    INVOKE InputInt
    mov a, eax

    INVOKE OutputStr, ADDR PROMPT4
    INVOKE Input
    mov b, eax

    	; ____________Preparing the registers for the multiplication________________
	    ; We will multiply EBX into EAX producing a result in EAX:EDX
    mov eax, g
    mov ebx, g

        ; _____________Setup a counter to count upwards__________________
    mov ecx, 1



        ; _____________Forloops__________________
forLoop1:   ; marks the begining of the loop
    
    cmp ecx, a      ; if a == counter
    je forEnd1      ; jump to forEnd1

    ; ___ForLoop body____
    mul ebx     ; multiply ebx into eax
    inc ecx     ; increment counter

    jmp forLoop1    ; start loop again
forEnd1:    ; marks end of the loop

	    ; _____mod p _____
	    ; Don't use CDQ in this instance, since we want to make use of the number already stored in EAX:EDX
	div p 				; Divide p into EAX:EDX.  Put the whole result in EAX and the remainder in EDX
	mov eax, edx        ; move the remainder into EAX so that we multiply again
	mov ebx, edx        ; Get EBX ready as well since we will multiple EBX into EAX later on.

	mov	exc, 1          ; Get the counter = 1



forLoop2: 
        
    cmp ecx, b          ; if counter == b
    je forEnd2          ; exit loop

    mul ecx             ; multiply ebx into eax
    inc ebx             
    jmp forLoop2

forEnd2:


        ;_______mod p again___________
        ; Don't use CDQ in this instance, since we want to make use of the number already stored in EAX:EDX 
    div p
    mov k, edx

    INVOKE OutputStr, ADDR ANSWER
    INVOKE OutputInt, k
    INVOKE OutputStr, ADDR NEWLINE


endProg: 
    ExitProcess, 0

Public _start
END



; *******************EXTRA NOTES**************************

; ______________________ DIFFERENCE BETWEEN JMP AND JE___________________________________


; ______________JMP (Jump)_________________
; Unconditional Jump: The jmp instruction causes an unconditional jump to a specified label. This means that execution will continue at the specified label regardless of any conditions.
; Syntax: jmp label
; Use Case: Typically used for looping, skipping code, or branching to another part of the program without evaluating any conditions.


; ______________JMP (Jump if Equals)_________________
; Conditional Jump: The je instruction is a conditional jump that occurs only if the zero flag (ZF) is set.
    ; The zero flag is set when the result of the last comparison (cmp) or test operation is zero (i.e., when the compared values are equal).
; Syntax: je label
; Use Case: Used for branching based on the result of a previous comparison. For example, it is used to jump to a specific part of the code if two values are equal.

