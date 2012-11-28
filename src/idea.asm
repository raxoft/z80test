
opsize      equ     4
datasize    equ     16
vecsize     equ     opsize+datasize

TEST:       ld      (.spptr+1),sp

            ld      a,(hl)
            ld      (.flagptr+1),a
            inc     hl

            ld      de,vector
            ld      bc,vecsize
            call    .copy

            add     hl,bc

            call    .copy

            call    .copy
            
            add     hl,bc

            ld      (.valptr+1),de

            inc     de

            call    .clear

            ld      (.maskptr+1),de

            xor     a
            ld      (de),a
            inc     de

            call    .copy

            exx
            ld      de,65535
            ld      b,d
            ld      c,e
            exx

            ld      sp,data.regs

            ; sequence combinator

.loop       ld      hl,counter
            ld      de,shifter+1
            ld      bc,vector
            ld      ix,.opcode
            
            macro   combine count,offset:0
            repeat  count
            ld      a,(bc)
            xor     (hl)
            ex      de,hl
            xor     (hl)
            ld      (ix+(@#+offset)),a
            if      @# < count-1
            inc     c
            inc     e
            inc     l
            endif
            endrepeat
            endm

            ld      a,(bc)
            xor     (hl)
            ex      de,hl
            xor     (hl)
            cp      0x76        ; halt
            jp      z,.next
            ld      (ix+0),a
            inc     c
            inc     e
            inc     l

            ld      a,(bc)
            xor     (hl)
            ex      de,hl
            xor     (hl)
            ld      (ix+1),a
            cp      0x76        ; halt
            jp      nz,.ok
            ld      a,(ix+0)
            and     0xDF        ; IX/IY prefix.
            cp      0xDD
            jp      z,.next
.ok         inc     c
            inc     e
            inc     l

            combine opsize-2,2

            ld      ix,data

            combine datasize

            ; test itself

            pop     af
            pop     bc
            pop     de
            pop     hl
            pop     ix
            pop     iy
            ld      sp,(data.sp)

.opcode     ds      opsize

            ld      (data.sp),sp
            ld      sp,data.regstop
            push    iy
            push    ix
            push    hl
            push    de
            push    bc
            push    af
            
            ld      hl,data

            ld      a,(hl)
.flagptr    and     0xff
            ld      (hl),a

            ; crc update

;           ld      hl,data
            ld      b,datasize

.crcloop    ld      a,(hl)
            exx
            xor     c

            ld      l,a
            ld      h,CRCTABLE/256
            
            ld      a,(hl)
            xor     b
            ld      c,a
            inc     h

            ld      a,(hl)
            xor     e
            ld      b,a
            inc     h

            ld      a,(hl)
            xor     d
            ld      e,a
            inc     h

            ld      d,(hl)

            exx

            inc     hl

            djnz    .crcloop

            ; multibyte counter with arbitrary bit mask


.next       ld      hl,countmask
            ld      de,counter
            ld      b,vecsize
.countloop  ld      a,(de)
            or      a
            jr      z,.countnext
            dec     a
            and     (hl)
            ld      (de),a
            jp      .loop
.countnext  ld      a,(hl)
            ld      (de),a
            inc     l
            inc     e
            djnz    .countloop

            ; multibyte shifter with arbitrary bit mask

.maskptr    ld      hl,shiftmask
.valptr     ld      de,shifter
            ld      a,(de)
            add     a,a
            neg
            add     (hl)
            xor     (hl)
            and     (hl)
            ld      (de),a
            jp      nz,.loop
.shiftloop  inc     l
            inc     e
            ld      a,e
            cp      shiftend % 256
            jr      z,.exit
            ld      a,(hl)
            dec     a
            xor     (hl)
            and     (hl)
            jr      z,.shiftloop
            ld      (de),a
            ld      (.maskptr+1),hl
            ld      (.valptr+1),de
            jp      .loop
.exit
.spptr      ld      sp,0
            ret

            ; misc helper routines

.copy       push    hl
            push    bc
            ldir
            pop     bc
            pop     hl
            ret

.clear      push    hl
            push    bc
            ld      h,d
            ld      l,e
            ld      (hl),0
            inc     de
            dec     bc
            ldir
            pop     bc
            pop     hl
            ret

            align   256

            include crctab.asm

            align   256

vector      ds      vecsize
counter     ds      vecsize
countmask   ds      vecsize
shifter     ds      1+vecsize
shiftend
shiftmask   ds      1+vecsize


            org     0xa000

data
.regs       ds      datasize-4
.regstop
.mem        ds      2
.sp         ds      2

