
            org     0x8000

MAIN:       di
            push    iy
            exx
            push    hl

            call    PRINTINIT

            ld      hl,TESTS
            jr      .entry

.loop       push    hl
            call    .test
            pop     hl

.entry      ld      e,(hl)
            inc     hl
            ld      d,(hl)
            inc     hl

            ld      a,d
            or      e
            jr      nz,.loop

            pop     hl
            exx
            pop     iy
            ei
            ret

.test
            ld      hl,1+3*vecsize
            add     hl,de
            push    hl

            call    PRINT
            db      "Test:",0

            ld      hl,1+3*vecsize+4
            add     hl,de

            call    PRINTHL

            ex      de,hl

            call    TEST

            exx
            ld      hl,.crc+3

            ld      (hl),e
            dec     hl
            ld      (hl),d
            dec     hl
            ld      (hl),c
            dec     hl
            ld      (hl),b

            pop     de

            ld      b,4
            call    .cmp

            ret     z

.mismatch   call    PRINT
            db      "Failed!",13
            db      "CRC:",0

            call    PRINTCRC

            call    PRINT
            db      " Expected:",0

            ex      de,hl
            call    PRINTCRC

            call    PRINT
            db      13,0

            ret

.cmp        push    hl
            push    de
.cmploop    ld      a,(de)
            cp      (hl)
            jr      nz,.exit
            inc     de
            inc     hl
            djnz    .cmploop
.exit       pop     de
            pop     hl
            ret

.crc        ds      4

            include print.asm
            include tests.asm
            include idea.asm

; EOF ;
