; Most x86 Assembly is not case sensitive
.386            ; This directive tells the assembler to generate code for the 80386 processor, enabling the use of 32-bit instructions
.MODEL FLAT     ; Specifies a flat memory model where all segments are assumed to be part of a single linear address space.
.STACK 4096     ; Allocates a stack of 4096 bytes for the program's use.

;__________Declares an external procedure (function) named ExitProcess that will be called to terminate the process___________
; NEAR32 stdcall, dwExitCode:DWORD -> specifies the calling convention (stdcall) and parameter type (DWORD) for ExitProcess
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD ;DWORD means Double Word. (in x86 a word is 16 bits (2bytes) so a Double Word is 32 bits(4bytes))
; PROTO is used to declare a prototype in assembly. it informs the assembler about existance of procedures and its calling convention
    ; ExitProcess is name of function
; the colon ":" is used to separate the parameter name from it's type.

; ____________data section stores all the global variables_______________
.DATA
p   DWORD   23  ; DWORD indicates the variables are 32 bits
q   DWORD   5  
k   DWORD   ?   ; ? means undefined

;_____________code section stores the program code_________________
.CODE
_start: ; indicates where program should start
    ; loading values into register
    MOV     EAX,    g   ; moves the value of g into the register EAX
    MOV     EDX,    g

    ; calculating g^a (23^4): imul multiplies EAX by EDX and stores the value in EAX, this is repeated 3 times to compute 5^4
    IMUL    EAX,    EDX     ; EAX = 5 * 5 = 25
    IMUL    EAX,    EDX     ; EAX = 25 * 5 = 125
    IMUL    EAX,    EDX     ; EAX = 125 * 5 = 625

    ; E.G1) if you wanted to multiply EAX amd EDX and store the result in ECX
    ; IMUL  ECX,    EAX,    EDX             => it looks like the first register is the Equals. Basically ECX = EAX * EDX

    ; E.G2) in another case, if you wanted to multiply EAX, EDX  and ECX, then store that value in ECX (YOU NEED AN EXTRA VARIABLE EBX)
        ; youd have to break it down in steps
        ;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
        ; Assume EAX=2, EDX=3, and ECX=4 contain the values you want to multiply

        ; mov     EBX, EAX     ; Move value of EAX into EBX for temporary storage                       mov EBX, EAX -> EBX now contains 2.
        ; imul    EBX, EDX     ; Multiply EBX by EDX, result stored in EBX (EBX = EAX * EDX)            imul EBX, EAX -> EBX now contains 2 * 3 = 6.
        ; imul    ECX, EBX     ; Multiply ECX by EBX, result stored in ECX (ECX = ECX * (EAX * EDX))    imul ECX, EBX -> ECX now contains 4 * 6 = 24.


    ; _____calculating g^a mod p_____

                ; CDQ is important if you want to perform an idiv
    CDQ         ;converts the value in register EAX to 64-bit value in EDX:EAX (sign-extended). CDQ means Convert Double to Quad
    ; When extending a number to a larger size, the sign is preserved (+ve or -ve)
    ; CDQ takes the value in EAX and sign-extends it into 'EDX:EAX'
    ; Meaning:
        ; EDX is set to 0        :  if EAX is +VE
        ; EDX is set to all 1's  :  if EAX is -VE

    IDIV    p   ; divides the 64 bit value in 'EDX:EAX' by 'p' (23)
    ; in this case we sign-extend EDX:EAX (meaning we get 0:625 because EAX=625 is positive) so EAX=625 and then divide by p=23
    ; then we store REMAINDER in EDX    &   QUOTIENT in EAX
                

    ; move the remainder into EAX so that we multiply again
    MOV     EAX,    EDX     ; moves the remainder (4) from EDX to EAX

    ; ____________calculate (g^a mod p)^b: calculates 4^3__________________
    IMUL    EAX,    EDX     ; EAX = 4 * 4 = 16
    IMUL    EAX,    EDX     ; EAX = 16 * 4 = 64
    
    ; calc ((g^a mod p)^b) mod p
    CDQ                     ; converts the value of EAX to a 64-bit value in EDX:EAX (0:64)
    MOV     EBX,    p       ; Move value of p into EBX      (so EBX=23)
    IDIV    EBX             ; EAX = 64 / 23, EDX = 64 % 23

    ; move the result into k
    MOV     k,     EDX  ; moves the remainder (18) from EDX to the variable k

    INVOKE ExitProcess, 0   ; calls the ExitProcess function with an argument 0 to terminate program

Public _start   ; makes _start label publicly accessible as the program's entry point
END             ; marks the end of program



