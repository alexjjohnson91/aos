[org 0x7c00]				; this is to specify where we want the boot sector to be loaded into memory
[bits 16]					; declare that this is 16 bit mode

section .text		; this is where we put the code
	global start	; declare the entry point for the code
start:

cli				; get rid of interrupts so that nothing weird happens

jmp 0x0000:zeroSeg	; to make sure the bios isn't doing any weird segmenting stuff
zeroSeg:
; clearing out the segment registers
	xor		ax, ax				; this is better practice to clear out a register
	mov		ss, ax				; now we use ax to clear out the segment registers
	mov		ds, ax				;
	mov		es, ax				;
	mov		fs, ax				;
	mov		gs, ax				;
	mov		sp, start			; set stack pointer to the entry point

; instating flags for the operating system
cld							; clear the direction flag so that we read strings L->R
sti							; reinstate interrupts

; reset the disk so that we are starting from the head and sector that we want
	mov		dl, 80h			
	int		0x13
; now read the rest of the data off of the disk
;	mov		al, 2				;
;	mov		cl, 1				;
;	call	readDisk			; function call

; testing the a20 line
	call	testA20

	jmp 	$					; halt the CPU
; include the functions
%include "func.asm"
%include "testA20.asm"
%include "enableA20.asm"

testStr:	db "Loading...", 0h					; test string for the second sector
e_disc:		db "Error loading disc", 0h			; error msg for the disc

; padding and the magic number
	TIMES 510 - ($ - $$) db 0	; this creates the padding bytes to fill empty space
	dw 0xaa55					; this is the magic number

	secTest:					; jump to the second sector and print the test string

	mov 	si, testStr		; testing the kernel disk reading
	call	PrintString		;

; pad out the second sector so that the kernel can read from the disk
	TIMES 512 db 0
