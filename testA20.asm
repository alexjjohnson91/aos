testA20:
    pusha                   ; we'll just push all the registers because I am lazy
    cli                     ; halt interrupts for the duration of the procedure
; first address [0000:0500]
    mov     si, teststr_1   ; print out message
    call    PrintString     ; 
    call    Printendl       ;
    mov     ax, WORD [0x7dfe]    ; this should give us the magic number
    mov     dx, ax
    call    PrintHexWord    ; print out the value
    call    Printendl

; second address [ffff:0510]
    mov     si, teststr_2   ; print out the second message
    call    PrintString     ;
    call    Printendl       ;
    mov     ax, 0xffff      ; this turns on every bit in ax
    mov     ds, ax          ; set the segment register
    mov     di, 0x0510      ; address register

    mov     bl, 0xff        ; now this turns bl into 0xff
    mov     BYTE [ds:di], bl; move 0xff into the second segmented address
    mov     dl, BYTE [ds:di]; print out the number
    call    PrintHexByte    ;
    call    Printendl       ;

    mov     dl, 0xff
    call    PrintHexByte
    call    Printendl

ta20_end:
    sti                     ; restore interrupts
    popa                    ; restore the registers
    ret                     ; end testa20
; end testA20

; messages for the function
e_disabled:     db "a20 line is disabled", 0h
e_enabled:      db "a20 line is enabled", 0h
teststr_1:      db "first, print the value from the first address", 0h
teststr_2:      db "now, print the value from the second address", 0h