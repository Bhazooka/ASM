.386
.MODEL FLAT
.STACK 4096

include io.inc

ExitProcess PROTO NEAR32 stdcall, dwExitCode: DWORD


.DATA
    ;======INPUT VARIABLES=====
    I                   DWORD       4 DUP (?)       ; Array of 4 DWORD sized items, DUP means duplicate (idk what its used for) 
    kernel              DWORD       ?
    bias                DWORD       ?
    
    ;======STRING PROMPTS======
    strKernelPrompt     BYTE        "Please provide the Kernel value (>0): ",0
    strBiasPrompt       BYTE        "Please provide the bias value (0-255): ",0
    strInputArr         BYTE        "Please input array item at index ",0
    strColon            BYTE        ":",0
    strNL               BYTE        10,0    ;New line character
    strQuit             BYTE        "Type 0 to quit: ",0
    strOutputHeader     BYTE        "Kernel",9,"Bias",9,"Input Array",9,"Output Array",10,0           ;9 is the tab character in the ASCII table. You can search this up   
    strTab              BYTE        9,0     ;Tab character
    strOpenBrackets     BYTE        "[", 0
    strCloseBrackets    BYTE        "]", 0
    strComma            BYTE        ",", 0

.CODE
_start:
    ;==== GET INPUT AND STORE DATA IN MEMORY====
    INVOKE      OutputStr,     ADDR strKernelPrompt
    INVOKE      InputInt                            ;when we input, the value is stored into the eax register
    mov         kernel,        eax


    INVOKE      OutputStr,     ADDR strBiasPrompt
    INVOKE      InputInt
    mov         bias,          eax

    ;====GET INPUT ARRAY====
        ;for(n=0; n<4; n++)
        ;   cin >> I[n]
    mov         eax,        0        ; counter for the forloop

StartInputLoop: 
    INVOKE      OutputStr,      ADDR strInputArr
    INVOKE      OutputInt,      ecx                 ;output the counter
    INVOKE      OutputStr,      ADDR strColon
    INVOKE      InputInt
    lea         ebx,            I

    ;calc offset in array offset = base + (ecx * 4)
    imul        eax,            ecx, 4      ;eax = ecx * 4
    add         ebx,            eax
    ;get input
    INVOKE      InputInt
    mov         [ebx],          eax
    inc         ecx,            4
    cmp         ecx,            4           ;compare (ecx and 4)
    jl          StartInputLoop              ;jump to startLoop if comparison evaluates to ecx < 4  

    ;====OUTPUT INITIAL SET OF VALUES=====
    INVOKE      OutputStr,      ADDR strOutputHeader
    INVOKE      OutputInt,      [kernel]
    INVOKE      OutputStr,      ADDR strTab
    INVOKE      OutputInt,      [bias]
    INVOKE      OutputStr,      ADDR strTab
    INVOKE      OutputStr,      ADDR strOpenBrackets

        ;for(n=0; n<4; n++)
        ;   cin >> I[n]
    mov         ecx,            0
    mov         
    
    

    
    INVOKE ExitProcess,0
Public _start
END