testA20:
    pusha                   ; we'll just push all the registers because I am lazy
    cli                     ; halt interrupts for the duration of the procedure
; first address [0000:0500]
    xor     ax, ax          ; this is for the first location
    mov     es, ax          ; first position [0000:0500]
    mov     si, 0x0500      ;
    
    xor     bl, bl          ; indirectly setting the value of the memory address
    mov     BYTE [es:si], bl;
    mov     dl, BYTE [es:si]; print out the number
    call    PrintHexByte    ;
    call    Printendl       ; 

; second address [ffff:0510]
    not     ax              ; this turns on every bit in ax
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