.386
.MODEL FLAT
.STACK 4096

INCLUDE io.inc
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA

PROMPT1 BYTE "Please enter g:",0    ; the ,0 is a null terminator that marks the end of the string
PROMPT2 BYTE "Please enter p:",0
ANSWER BYTE "The ephemeral key k=",0
NEWLINE BYTE 10,0       ; 10 is the ASCII code for the new line character, 0 is the null terminator

; Variables
p   DWORD   ?
g   DWORD   ?
k   DWORD   ?


.CODE
_start:

        ; Invoke macro is used to call procedure in assembly languages
    INVOKE OutputStr, ADDR PROMPT1  
            ; INVOKE OutputStr --> This is a procedure, likely defined in the included io.inc file, that takes a string address as a parameter and outputs the string to the console.
            ; ADDR PROMPT --> This gets the address of the PROMPT1 string ("Please enter g:") and passes it to the OutputStr procedure.
    INVOKE InputInt 
            ; InputInt: This is another procedure defined in io.inc. It waits for the user to input an integer value from the keyboard, then stores the result in the EAX register.            

    mov g, eax  
            ; moves the value stored into the eax register into g

    ; EAX register as Default for return value.
    ; Function Return Values:
    ; In many calling conventions, the EAX register is designated as the place where a function returns its result. This is a widely 
    ; adopted convention because it provides a standard location for functions to place their return values, simplifying the calling and return process. 
    ; For example, in the cdecl and stdcall conventions, which are commonly used in Windows API and other C libraries, functions return their values in EAX

    INVOKE OutputStr, ADDR PROMPT2
    INVOKE InputInt
    mov p, eax

    mov eax, g
    mov edx, g

        ; g ^ a  (23 ^ 4)
    imul eax, edx   ; If you used mul then the behaviour would have been different.  mul zeros EDX
    imul eax, edx   ; while imul using two operands potentially only affects the destination operand.
    imul eax, edx

        ; mod p 
    CDQ
    idiv p  
            ; Divide p into EAX.  Put the whole result in EAX and the remainder in EDX

        ; move the remainder into EAX so that we multiply again
    mov eax, edx

    ; ^ b (^ 3)
    imul eax, edx
    imul eax, edx

        ; mod p again
    CDQ
    mov ebx, p
    idiv ebx

    mov k, edx

    
	    ; Output the result
	INVOKE	OutputStr, ADDR ANSWER
            ; ADDR ANSWER and ADDR NEWLINE are used to pass the address of the ANSWER and NEWLINE strings, respectively, to the OutputStr procedure.
            ; ADDR is necessary here because OutputStr expects a pointer to the start of the string. By using ADDR, you provide the address where the string begins in memory.

	    ; Output the variable k
	INVOKE 	OutputInt,	k
            ; k is a variable that holds an integer value.
            ; OutputInt is a procedure that outputs an integer, and it expects the integer value itself, not a pointer to the integer.
            ; Therefore, you pass the value of k directly, not its address.

	    ; Outputting a newline character after the answer.
	INVOKE  OutputStr, ADDR NEWLINE



    INVOKE ExitProcess, 0

Public _start
END









