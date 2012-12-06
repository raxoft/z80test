# gmake

NAME = z80test
VERSION = 0.1
PKG := $(NAME)-$(VERSION)

PROGS := z80full z80flags z80doc z80docflags z80ccf z80memptr
SRCS  := main idea crctab tests testmacros print

all: $(addsuffix .tap,$(PROGS))

.DELETE_ON_ERROR: %.out

%.out : %.asm $(addsuffix .asm,$(SRCS))
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
