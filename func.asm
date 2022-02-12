PrintString:
	pusha					; push everything to the stack
	str_loop:				; this will be the loop to print the string
		mov		al, [si]	; this moves the character into the register
		cmp		al, 0		; check if we are at the end of the string 
		je		printEnd	; if we are at the end, terminate the function
		; otherwise we need to print the character
		mov		ah, 0x0e	; the character used for the print interrupt
		int 	0x10		; tickle the kernel
		inc		si			; move si to the next char
		jmp		str_loop	; continue the loop
	printEnd: 				; this is the label to end the function 
	popa					; restore the registers 
	ret						; return from the function
; end printf

Printendl:
	push	ax				; push the registers that we need to use
	mov		ah, 0xe			; charater to move curser

	mov		al, 0xa			; new line ascii
	int		0x10			; kernel interrupts

	mov		al, 0xd			; carraige return
	int 	0x10			; kernel interrupt

	pop		ax				; restore the register
	ret						; end Printendl

readDisk:
	pusha					; push all of the register for the function 
	mov		ah, 0x02		; move 2 into ah
	mov		dl, 0x80		; select the hard drive
	mov		ch, 0
	mov		dh, 0

	push	bx
	mov		bx, 0h
	mov		es, bx
	pop		bx
	mov		bx, 7c00h
	add		bx, 512d		; this will load us into the correct space in memory
	int		0x13			; tickle the kernel

	jc		discErr			; if the carry flag is set, then we have an error
	popa					; terminate the function
	ret
; end ReadDisk

discErr:
	mov		si, e_disc		; print the error message
	call	PrintString		;
	call	Printendl		;
	jmp $					; and hang in this space

PrintHexWord:
	pusha					; push all the registers in order to save them

	mov		al, 4			; set the counter register for the loop
	mov		cl, 12			; shifting the registers
	mov		di, 2			; increasing the hex pattern


	hex_print_loop:
		mov		bx, dx			; make a copy of bx by putting it into dx
		shr		bx, cl			; shift the bx register 12 bits
		and		bx, 000fh		; bit masking the register
		mov		bx, [bx + hex_table]
		mov		[hex_word_pat + di], bl

		sub		cl, 4			;decrease the shifting value of the register
		inc		di				; moving the hex pattern value

	; loop condition
		cmp		al, 1			; if al is 0, then the loop is over
		je		hex_print_end	; end the function
		dec		al				; otherwise, decrement al and continue
		jmp		hex_print_loop	
	hex_print_end:			; here is the label to end the function

	mov		si, hex_word_pat	; move the hex pattern into si and print to the screen
	call	PrintString			;
	call	Printendl

	popa					; restore the registers
	ret
; end PrintHex

hex_word_pat: 	db "0x****", 0h
hex_table:	db "0123456789abcdef"

PrintHexByte:
	pusha					; push all the registers in order to save them

	mov		al, 2			; set the counter register for the loop
	mov		cl, 4			; shifting the registers
	mov		di, 2			; increasing the hex pattern


	hex_byte_print_loop:
		mov		bl, dl			; make a copy of bx by putting it into dx
		shr		bl, cl			; shift the bx register 12 bits
		and		bl, 0fh		; bit masking the register
		mov		bl, [bx + hex_table]
		mov		[hex_byte_pat + di], bl

		sub		cl, 4			;decrease the shifting value of the register
		inc		di				; moving the hex pattern value

	; loop condition
		cmp		al, 1			; if al is 0, then the loop is over
		je		hex_byte_print_end	; end the function
		dec		al				; otherwise, decrement al and continue
		jmp		hex_byte_print_loop	
	hex_byte_print_end:			; here is the label to end the function

	mov		si, hex_byte_pat	; move the hex pattern into si and print to the screen
	call	PrintString			;
	call	Printendl

	popa					; restore the registers
	ret
; end PrintHex

hex_byte_pat: 	db "0x**", 0h