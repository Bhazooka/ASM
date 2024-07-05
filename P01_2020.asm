.386
.MODEL FLAT
.STACK 4096

INCLUDE io.inc
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA

PROMTP1 BYTE "Please enter g:",0
PROMPT2 BYTE "Please enter p:",0
ANSWER BYTE "The ephemeral key k=",0
NEWLINE BYTE 10,0

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
    INVOKE InputInt ; InputInt: This is another procedure defined in io.inc. It waits for the user to input an integer value from the keyboard, then stores the result in the EAX register.            

    mov g, eax  ; moves the value stored into the eax register into g
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

    imul eax, edx
    imul eax, edx
    imul eax, edx

    CDQ
    idiv p

    mov eax, edx

    imul eax, edx
    imul eax, edx

    CDQ
    mov ebx, p
    idiv ebx

    mov k, edx

    
    INVOKE OutputStr, ADDR ANSWER
    INVOKE OutputStr, k
    INVOKE OutputStr, ADDR NEWLINE

    INVOKE ExitProcess, 0
    
Public _start
END