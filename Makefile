# SPDX-License-Identifier: GPL-2.0
PROGS := exit
PROGS += fp
PROGS += int
PROGS += mem
PROGS += reg
PROGS += add
PROGS += sum
PROGS += sub
PROGS += add2
PROGS += sub2
PROGS += imul
PROGS += imul2
PROGS += imul3
PROGS += pytha
PROGS += idiv
PROGS += bts
PROGS += jmp
PROGS += swap
PROGS += max
PROGS += mid
PROGS += count
PROGS += search
ASMS  := $(patsubst %,%.asm,$(PROGS))
SRCS  := $(wildcard *.c)
DASMS := $(patsubst %.c,%.s,$(SRCS))
all: $(PROGS)
$(PROGS): $(ASMS) $(DASMS)
	yasm -f elf64 -g dwarf2 -l $@.lst $@.asm
	gcc -static -o $@ $@.o
%.s: %.c
	gcc -O3 -S -masm=intel $<
.PHONY: test clean
test: $(PROGS)
	@for prog in $^;                  \
	do printf "$$prog:\t";            \
		if ./$$prog;              \
		then echo "PASS";         \
		else echo "FAIL"; exit 1; \
		fi;                       \
	done
clean:
	@$(RM) $(PROGS) *.o *.s *.lst
# Docker based compilation.
.PHONY: amd64
amd64: amd64-image
	docker run -v $(PWD):/home/build x86/$@ make all clean
%-image:
	docker build -t x86/$* -f Dockerfile.$* .
%-amd64: amd64-image
	docker run -v $(PWD):/home/build x86/amd64 make $* clean
