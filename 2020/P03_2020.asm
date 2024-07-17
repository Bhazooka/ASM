; Author: Dr J du Toit
; Practical: 03
.386
.MODEL FLAT ; Flat memory model
.STACK 4096 ; 4096 bytes

; Include IO
INCLUDE io.inc

; Exit function
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
; Strings
HEADING     BYTE    "Please type 15 numbers between 1 and 10.",10,0
MSG_INPUT   BYTE    "Number (1-10):",0
MSG_ERROR   BYTE    "You did not type in a value from 1 to 10, please try again.",0,10
MSG_OUTPUT  BYTE    "The sorted array is:",10,0
COMMA       BYTE    ",",0
NEWLINE     BYTE    10,0
NUM_ITEMS   DWORD   15

; Input
arrNums     DWORD   15 DUP (?)       ; Array of 15 numbers
intTemp     DWORD   ?

.CODE
_start:
;=================================================================================
;                          Input Section
;=================================================================================
    ; cout << "Please type 15 numbers between 1 and 10." << endl;
    INVOKE  OutputStr, ADDR HEADING
    mov     ecx, NUM_ITEMS          ; Load the loop counter into ecx
    lea     ebx, arrNums            ; Load effective address of arrNums into ebx
forInputStart:
    INVOKE  OutputStr, ADDR MSG_INPUT
    INVOKE  InputInt
    ; See if the range is within 1 and 10
    ; if(eax < 1 || eax > 10) then goto errInput label
    cmp     eax, 1                  ; Compare input with 1
    JL      errInput                ; Jump to errInput if Less than 1
    cmp     eax, 10                 ; Compare input with 10
    JG      errInput                ; Jump to errInput if Greater than 10
    ; No error input, we now need to store the input 
    mov     [ebx], eax              ; Store input in the array
    add     ebx, 4                  ; Move to the next array element (each is 4 bytes)
    loop    forInputStart           ; Loop back if ecx is not zero, decrement ecx
    jmp     forInputDone            ; Jump to forInputDone if done
errInput:
    ; This section will output an error message and request that the user try again.
    INVOKE  OutputStr, ADDR MSG_ERROR
    jmp     forInputStart           ; Retry input
forInputDone:

;=================================================================================
;                                 Bubble Sort Section
;=================================================================================
    ; Basic bubble sort
    ;----------------------Outer loop start-------------------------
    ; We will use ecx as the counter for the outer loop 
    mov     ecx, 0                  ; for(i=0)(ecx=i)
forOuterLoop:
    mov     ebx, NUM_ITEMS          ; Load number of items into ebx
    dec     ebx                     ; Decrement ebx (NUM_ITEMS-1)
    cmp     ecx, ebx                ; Compare ecx with NUM_ITEMS-1
    jge     forOuterLoopEnd         ; Jump if ecx >= NUM_ITEMS-1 (end of outer loop)
    ;----------------------Inner loop start-------------------------
    ; We will use edx as the counter for the inner loop
    mov     edx, 0                  ; for(j=0)(edx=j)
forInnerLoop:
    mov     ebx, NUM_ITEMS          ; Load number of items into ebx
    dec     ebx                     ; Decrement ebx (NUM_ITEMS-1)
    sub     ebx, ecx                ; Subtract outer loop index (NUM_ITEMS-1-i)
    cmp     edx, ebx                ; Compare edx with NUM_ITEMS-1-i
    jge     forInnerLoopEnd         ; Jump if edx >= NUM_ITEMS-1-i (end of inner loop)
    ; detail of inner loop below here
    mov     eax, 4                  ; We have to offset the address in the array with the (j x 4)
    imul    eax, edx                ; Multiply edx by 4 to get the offset (4 bytes per DWORD)
    lea     ebx, arrNums            ; Get the base address of array into ebx 
    add     ebx, eax                ; Add offset to base address
    mov     eax, [ebx]              ; Load arrNums[j] into eax
    cmp     eax, [ebx+4]            ; Compare arrNums[j] with arrNums[j+1]
    jle     ifNotLess               ; Jump if arrNums[j] <= arrNums[j+1]
    mov     intTemp, eax            ; int intTemp = arrNums[j];
    mov     eax, [ebx+4]            ; Load arrNums[j+1] into eax
    mov     [ebx], eax              ; arrNums[j] = arrNums[j+1]
    mov     eax, intTemp            ; Load intTemp into eax
    mov     [ebx+4], eax            ; arrNums[j+1] = intTemp;
ifNotLess:
    inc     edx                     ; Increment edx (j++)
    jmp     forInnerLoop            ; Loop back to forInnerLoop
    ;----------------------Inner loop end-------------------------
forInnerLoopEnd:    
    inc     ecx                     ; Increment ecx (i++)
    jmp     forOuterLoop            ; Loop back to forOuterLoop
    ;----------------------Outer loop end-------------------------
forOuterLoopEnd:

;=================================================================================
;                                Output Section
;=================================================================================
    INVOKE  OutputStr, ADDR MSG_OUTPUT   ; cout << "The sorted array is:" << endl;
    mov     ecx, NUM_ITEMS               ; Load loop counter with number of items
    lea     ebx, arrNums                 ; Load effective address of arrNums
forOutputStart:
    mov     eax, [ebx]                   ; Load current array element into eax
    INVOKE  OutputInt, eax               ; Output the integer
    INVOKE  OutputStr, ADDR COMMA        ; Output a comma
    add     ebx, 4                       ; Move to the next array element
    loop    forOutputStart               ; Loop back if ecx is not zero, decrement ecx
forOutputEnd:

; Exit
    INVOKE ExitProcess, 0
Public _start
END









; **************************** EXTRA ************************************
; lea (Load Effective Address): Calculates the address of the memory operand and stores it in the specified register. It's commonly used for address calculations.

; JL (Jump if Less): Jumps to the specified label if the comparison sets the less-than flag (i.e., the signed result is less than zero).

; JG (Jump if Greater): Jumps to the specified label if the comparison sets the greater-than flag (i.e., the signed result is greater than zero).

; dec (Decrement): Decreases the value of the specified operand by 1.

; sub (Subtract): Subtracts the second operand from the first and stores the result in the first operand.

; jge (Jump if Greater or Equal): Jumps to the specified label if the comparison sets the greater-than-or-equal flag (i.e., the signed result is greater than or equal to zero).

; jle (Jump if Less or Equal): Jumps to the specified label if the comparison sets the less-than-or-equal flag (i.e., the signed result is less than or equal to zero).

; inc (Increment): Increases the value of the specified operand by 1.

; loop: Decrements the ecx register and jumps to the specified label if ecx is not zero.



; mov [ebx], eax: This instruction moves the value in the eax register into the memory location pointed to by the ebx register.
; ebx contains an address.
; The value in eax is stored in the memory location at that address.