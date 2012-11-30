testtable:
            dw      .crc
            dw      .counter
            dw      .shifter
            dw      .selftest
            dw      0

            ; macros for defining the test vectors.

            macro   db8 b7,b6,b5,b4,b3,b2,b1,b0
            db      (b7<<7)|(b6<<6)|(b5<<5)|(b4<<4)|(b3<<3)|(b2<<2)|(b1<<1)|b0
            endm
            
            macro   ddbe n
            db      (n>>24)&0xff
            db      (n>>16)&0xff
            db      (n>>8)&0xff
            db      n&0xff
            endm
            
            macro   flags sn,s,zn,z,f5n,f5,hcn,hc,f3n,f3,pvn,pv,nn,n,cn,c
            if      maskflags
            db8     s,z,f5,hc,f3,pv,n,c
            else
            db      0xff
            endif
            endm

            macro   vec op1,op2,op3,op4,memn,mem,an,a,fn,f,bcn,bc,den,de,hln,hl,ixn,ix,iyn,iy,spn,sp
            db      op1,op2,op3,op4
            db      f,a
            dw      bc,de,hl,ix,iy
            dw      mem
            dw      sp
            endm

            macro   crcs allflagsn,allflags,alln,all,docflagsn,docflags,docn,doc
            if      maskflags
            if      onlyflags
            ddbe   docflags
            else
            ddbe   doc
            endif
            else
            if      onlyflags
            ddbe   allflags
            else
            ddbe   all
            endif
            endif
            endm
            
            macro   name n
            dz      n
            endm

            ; test vectors themselves.

.crc        flags   s,1,z,1,f5,0,hc,1,f3,0,pv,1,n,1,c,1
            vec     0x00,0x00,0x00,0x00,mem,0x1234,a,0xaa,f,0xff,bc,0xbbcc,de,0xddee,hl,0x4411,ix,0xdd88,iy,0xfd77,sp,0xc000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x00,f,0x00,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x0000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x00,f,0x00,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x0000
;           crcs    allflags,0xaf0f0011,all,0xac0f0022,docflags,0xdf0f0033,doc,0xdc0f0044
            crcs    allflags,0x00ffffff,all,0x2e26825b,docflags,0x354a5705,doc,0x4a0a6669
            name    "CRC TEST"

.counter    flags   s,1,z,1,f5,0,hc,1,f3,0,pv,1,n,1,c,1
            vec     0x00,0x00,0x00,0x00,mem,0x1234,a,0xaa,f,0xff,bc,0xbbcc,de,0xddee,hl,0x4411,ix,0xdd88,iy,0xfd77,sp,0xc000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x01,f,0x00,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x8000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x00,f,0x00,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x0000
            crcs    allflags,0x00000000,all,0x65283e9d,docflags,0x3b3096d9,doc,0x70844659
            name    "COUNTER TEST"

.shifter    flags   s,1,z,1,f5,0,hc,1,f3,0,pv,1,n,1,c,1
            vec     0x00,0x00,0x00,0x00,mem,0x1234,a,0xaa,f,0xff,bc,0xbbcc,de,0xddee,hl,0x4411,ix,0xdd88,iy,0xfd77,sp,0xc000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x00,f,0x00,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x0000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x41,f,0x00,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x8000
            crcs    allflags,0x00000000,all,0xd690f8ac,docflags,0x3b3096d9,doc,0xc33c8068
            name    "SHIFTER TEST"


.selftest   flags   s,1,z,1,f5,0,hc,1,f3,0,pv,1,n,1,c,1
            vec     0x00,0x00,0x00,0x00,mem,0x1234,a,0xaa,f,0xff,bc,0xbbcc,de,0xddee,hl,0x4411,ix,0xdd88,iy,0xfd77,sp,0xc000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x00,f,0x20,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x0000
            vec     0x00,0x00,0x00,0x00,mem,0x0000,a,0x00,f,0x08,bc,0x0000,de,0x0000,hl,0x0000,ix,0x0000,iy,0x0000,sp,0x0000
            crcs    allflags,0xf3b489a6,all,0x1052d099,docflags,0x3b3096d9,doc,0x48e530ef
            name    "SELF TEST"
