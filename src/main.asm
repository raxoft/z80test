
            org     0x8000

main:       di
            push    iy
            exx
            push    hl

            call    printinit

            ld      bc,0
            ld      hl,testtable
            jr      .entry

.loop       push    hl
            push    bc
            call    .test
            pop     bc
            pop     hl

            add     a,b
            ld      b,a

            inc     c

.entry      ld      e,(hl)
            inc     hl
            ld      d,(hl)
            inc     hl

            ld      a,d
            or      e
            jr      nz,.loop

            call    print
            db      13,"Result: ",0

            ld      a,b
            call    printdeca

            call    print
            db      " of ",0

            ld      a,c
            call    printdeca

            call    print
            db      " tests failed.",13,0

            pop     hl
            exx
            pop     iy
            ei
            ret

.test       ld      hl,1+3*vecsize
            add     hl,de
            push    hl

            ld      a,c
            call    printdeca

            ld      a,' '
            call    printchr

            ld      hl,1+3*vecsize+4
            add     hl,de

            call    printhl

            ex      de,hl

            call    test

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

            jr      nz,.mismatch

            call    print
            db      23,32-2,1,"OK",13,0

            ret

.mismatch   call    print
            db      23,32-6,1,"FAILED",13
            db      "CRC:",0

            call    printcrc

            call    print
            db      "   Expected:",0

            ex      de,hl
            call    printcrc

            ld      a,13
            call    printchr

            ld      a,1
            ret

.cmp        push    hl
            push    de
.cmploop    ld      a,(de)
            xor     (hl)
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
