.386
.MODEL FLAT
.STACK 4096

; Declares an external procedure (function) named ExitProcess that will be called to terminate the process
; NEAR32 stdcall, dwExitCode:DWORD -> specifies the calling convention (stdcall) and parameter type (DWORD) for ExitProcess
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD ;

.DATA
p   DWORD   23
q   DWORD   5
k   DWORD   ?

.CODE
_start:
    ; loading values into register
    MOV     EAX,    g   ; moves the value of g into the register EAX
    MOV     EDX,    g

    ; calculating g^a (23^4): imul multiplies EAX by EDX and stores the value in EAX, this is repeated 3 times to compute 5^4
    IMUL    EAX,    EDX     ; EAX = 5 * 5 = 25
    IMUL    EAX,    EDX     ; EAX = 25 * 5 = 125
    IMUL    EAX,    EDX     ; EAX = 125 * 5 = 625

    ; calculating g^a mod p
    CDQ         ; converts the value in register EAX to 64-bit value in EDX:EAX (sign-extended)
    IDIV    p   ; divides the 64 bit value in 'EDX:EAX' by 'p' (23)

    ; move the remainder into EAX so that we multiply again
    MOV     EAX,    EDX     ; moves the remainder (4) from EDX to EAX

    ; calculate (g^a mod p)^b: calculates 4^3
    IMUL    EAX,    EDX     ; EAX = 4 * 4 = 16
    IMUL    EAX,    EDX     ; EAX = 16 * 4 = 64
    
    ; calc ((g^a mod p)^b) mod p
    CDQ                     ; converts the value of EAX to a 64-bit value in EDX:EAX
    MOV     EBX,    p
    IDIV    EBX       

    ; move the result into k
    MOV     k,     EDX  ; moves the remainder (18) from EDX to the variable k

    INVOKE ExitProcess, 0   ; calls the ExitProcess function with an argument 0 to terminate program

Public _start   ; makes _start label publicly accessible as the program's entry point
END             ; marks the end of program

