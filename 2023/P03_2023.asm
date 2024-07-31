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
    mov         ecx,        0        ; counter for the forloop

StartInputLoop: 
    INVOKE      OutputStr,      ADDR strInputArr
    INVOKE      OutputInt,      ecx                 ;output the counter
    INVOKE      OutputStr,      ADDR strColon
    lea         ebx,    I

    ;calc offset in array offset = base + (ecx * 4)
    imul        eax,            ecx, 4      ;eax = ecx * 4
    add         ebx,            eax
    ;get input
    INVOKE      InputInt
    mov         [ebx],          eax
    inc         ecx
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

StartOutputALoop:
    lea         ebx,            I
    ; Calculate the offset in the array offset = base + (ecx * 4)
    imul        eax, ecx, 4     ; eax = ecx * 4
    add         ebx, eax

    ; Read the value from the array
    INVOKE      OutputInt,  [ebx]
    cmp         ecx,    3
    je          SkipCommaA
    INVOKE      OutputInt,  ADDR     strComma   

SkipCommaA:
    inc         ecx
    cmp         ecx,    4   ; if(ecx < 4) gotoStartOutput
    jl          StartOutputALoop

    INVOKE      OutputStr, ADDR strCloseBrackets
    INVOKE      OutputStr, strTab
    INVOKE      OutputStr, strOpenBrackets
        ;for(n=0;n<4;n++)
        ; cout << (I[n]/kernel + bias)
    
    mov         ecx, 0
    
StartOutputBLoop:
    lea         ebx,    I
    imul        eax,    ecx, 4
    add         ebx,    eax
    ; Prepare for d
    mov         edx,    0
    mov         eax,    [ebx]         ; eax = (edx:eax)/kernel + bias
    div         [kernel]
    add         edx,    [bias]

    ; See if the answer is greater than 255
    ; if(eax<=2)

    cmp         eax,    255
    jle         LessThan
    mov         eax,    255

LessThan:
    INVOKE      OutputInt, eax
    cmp         ecx,    3
    jle         SkipCommaB
    INVOKE      OutputStr, ADDR strComma
SkipCommaB:
    inc         ecx
    cmp         ecx,    4
    jl          StartOutputBLoop

    INVOKE      OutputStr,  ADDR strCloseBrackets
    INVOKE      OutputStr,  ADDR strNL


    ; =================== Get the Quit Prompt ====================
    INVOKE      OutputStr, ADDR strQuit
    INVOKE      InputInt
        ;if(ecx!=0)
        ;   go to start
    cmp         eax, 0
    jne          _start

    
    INVOKE ExitProcess,0
Public _start
END