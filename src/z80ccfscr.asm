; Z80 test - monitor random behavior of bits 5 and 3 after CCF.
;
; Copyright (C) 2023 Patrik Rak (patrik@raxoft.cz)
;
; This source code is released under the MIT license, see included license.txt.

            org     0x8000

main:       di
            ld      sp,22528+512
            ld      hl,0x7838
            ld      b,0
.fill       push    hl
            djnz    .fill
            ld      sp,49152
            ld      hl,16384
            ld      d,0xEF
.loop       push    hl
            pop     af
            ccf
            push    af
            pop     bc
            ld      a,l
            xor     c
            ld      (hl),a
            inc     hl
            ld      a,h
            and     d
            ld      h,a
            jp      .loop

; EOF ;
