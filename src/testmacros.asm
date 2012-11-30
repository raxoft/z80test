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

            macro   vec op1,op2,op3,op4,memn,mem,an,a,fn,f,bcn,bc,den,de,hln,hl,ixn,ix,iyn,iy,spn,sp,fmaskn:fmask,fmask:%11010111
            db      op1,op2,op3,op4
            if      maskflags
            db      f & fmask
            else
            db      f
            endif
            db      a
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
