.386
.MODEL FLAT
.STACK 4096

INCLUDE io.inc

ExitProcess PROTO NEAR32 stdcall,dwExitcode:DWORD

.DATA
HEADING     BYTE    "Please type 15 numbers between 1 and 10.",10,0
MSG_INPUT   BYTE    "Number (1-10):",0
MSG_ERROR   BYTE    "You did not type in a value from 1 to 10, please try again."
MSG_OUTPUT  BYTE    "The sorted array is:",10,0
COMMA       BYTE    ",",0
NEWLINE     BYTE    10,0
NUM_ITEMS   DWORD   15


arrNums     DWORD   15 DUP (?)      ; Array of 15 Numbers
intTemp     DWORD   ?

.CODE
_start

    



Public _start
END