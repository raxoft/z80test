; Main driver for the Z80 tester.
;
; Copyright (C) 2012 Patrik Rak (patrik@raxoft.cz)
;
; This source code is released under the MIT license, see included license.txt.

            org     0x8000

main:       di                                  ; disable interrupts
            push    iy                          ; preserve stuff needed by BASIC
            exx
            push    hl

            call    printinit                   ; init printing module

            call    print                       ; print the header
            db      "Z80 "
            testname
            db      " test"
            db      23,32-13,1,127," 2012 RAXOFT",13,13,0

            ld      bc,0                        ; setup for test loop
            ld      hl,testtable
            jr      .entry

.loop       push    hl                          ; call the test wrapper
            push    bc
            call    .test
            pop     bc
            pop     hl

            add     a,b                         ; accumulate failures
            ld      b,a

            inc     c                           ; count number of tests

.entry      ld      e,(hl)                      ; fetch test address
            inc     hl
            ld      d,(hl)
            inc     hl

            ld      a,d                         ; loop until we are done
            or      e
            jr      nz,.loop

            call    print                       ; print result intro
            db      13,"Result: ",0

            ld      a,b                         ; no failures means success
            or      a
            jr      z,.ok

            call    printdeca                   ; print number of failed tests

            call    print
            db      " of ",0

            ld      a,c
            call    printdeca

            call    print
            db      " tests failed.",13,0
            jr      .done

.ok         call    print                       ; print success message
            db      "all tests passed.",13,0

.done       pop     hl                          ; return to BASIC
            exx
            pop     iy
            ei
            ret

.test       ld      hl,1+3*vecsize              ; store expected CRC address
            add     hl,de
            push    hl

            ld      a,c                         ; print test number
            call    printdeca

            ld      a,' '
            call    printchr

            ld      hl,1+3*vecsize+4            ; print test name
            add     hl,de

            call    printhl

            ex      de,hl                       ; run the test with test vector at HL

            call    test

            ld      hl,data+3                   ; store computed CRC

            ld      (hl),e
            dec     hl
            ld      (hl),d
            dec     hl
            ld      (hl),c
            dec     hl
            ld      (hl),b

            pop     de                          ; get expected CRC address

            ld      b,4                         ; compare CRCs
            call    .cmp

            jr      nz,.mismatch                ; check for mismatch

            call    print                       ; print success
            db      23,32-2,1,"OK",13,0

            ret                                 ; return success

.mismatch   call    print                       ; print mismatched and expected CRC
            db      23,32-6,1,"FAILED",13
            db      "CRC:",0

            call    printcrc

            call    print
            db      "   Expected:",0

            ex      de,hl
            call    printcrc

            ld      a,13
            call    printchr

            ld      a,1                         ; return failure
            ret

.cmp        push    hl                          ; compare B bytes at HL and DE
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

            include print.asm
            include idea.asm
            include tests.asm

; EOF ;
