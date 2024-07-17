.386
.MODEL FLAT
.STACK 4096

ExitProcess NEAR32 PROTO stdcall, dwExitCode:DWORD

.DATA
intRed      DWORD   224
intGreen    DWORD   82 
intBlue     DWORD   6
intGray     DWORD   ?


.CODE
_start: 

    ; intRed * 3
    mov     EAX,    intRed
    mov     EBX,    3
    mul     EBX

    ;EDX:EAX / 10
    mov     EBX,    10
    div     EBX
    mul     ECX,    EAX     ; temporarily storing answer in ECX

    ; intGreen * 6
    mov     EAX,    intGreen
    mov     EBX,    6
    mul     EBX

    ;EDX:EAX / 10
    mov     EBX,    10
    div     EBX
    add     ECX,    EAX     ; ECX = ECX + EAX

    ; intBlue * 6
    mov     EAX,    intBlue
    mov     EBX,    1
    mul     EBX

    ;EDX:EAX / 10
    mov     EBX,    10
    div     EBX
    add     ECX,    EAX     ; ECX = ECX + EAX
    
    ; move the final answer to intGray
    mov     intGray,    ECX

    INVOKE ExitProcess, 0
Public _start
END