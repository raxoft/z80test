
        org     0x8000

MAIN:   di
        push    iy
        exx
        push    hl

        ld      hl,TESTS

.loop   ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl

        ld      a,d
        or      e
        jr      z,.exit

        push    hl

        ex      de,hl

        call    TEST

        pop     hl

        jr      .loop

.exit   pop     hl
        exx
        pop     iy
        ei
        ret

        include tests.asm

        include idea.asm
