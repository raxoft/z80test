# gmake

NAME = z80ft
VERSION = 0.1
PKG := $(NAME)-$(VERSION)

PROGS := z80ft
SRCS  := idea crctab tests print

all: $(addsuffix .tap,$(PROGS))

z80ft.out: z80ft.asm $(addsuffix .asm,$(SRCS))

.DELETE_ON_ERROR: %.out

%.out : %.asm
	sjasm $<

%.tap : loader.bas %.out
	mktap -b $(basename $(word 1,$^)) 10 <$(word 1,$^) >$@
	mktap    $(basename $(word 2,$^)) 32768 <$(word 2,$^) >>$@

FILES := Makefile loader.bas $(addsuffix .asm,$(PROGS)) $(addsuffix .tap,$(PROGS)) $(addsuffix .asm, $(SRCS))

dist:
	ln -s . $(PKG)
	tar czf $(PKG).tar.gz --group=root --owner=root $(addprefix $(PKG)/, $(FILES))
	zip $(PKG).zip $(addprefix $(PKG)/, $(FILES))
	rm $(PKG)

clean:
	rm -rf *.out *.lst *.tap

tidy: clean
	rm -rf $(PROGS)
