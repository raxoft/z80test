

PRINTINIT:  ld      a,2
            jp      0x1601      ; CHAN-OPEN

PRINT:      ex      (sp),hl
            call    PRINTHL
            ex      (sp),hl
            ret

PRINTHL:
.loop       ld      a,(hl)
            inc     hl
            or      a
            ret     z
            call    PRINTCHR
            jr      .loop

PRINTCRC:   ld      b,4

PRINTHEXS:
.loop       ld      a,(hl)
            inc     hl
            call    PRINTHEXA
            djnz    .loop
            ret

PRINTHEXA:  push    af
            rrca
            rrca
            rrca
            rrca
            call    .nibble
            pop     af

.nibble     or      0xf0
            daa
            add     a,0xa0
            adc     a,0x40

PRINTCHR:   push    iy
            ld      iy,0x5c3a   ; ERR-NR
            ei
            rst     0x10
            di
            pop     iy
            ret
