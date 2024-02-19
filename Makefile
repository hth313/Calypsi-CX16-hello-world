VPATH = src

# Common source files
ASM_SRCS =
C_SRCS = main.c

# Object files
OBJS = $(ASM_SRCS:%.s=obj/%.o) $(C_SRCS:%.c=obj/%.o)
OBJS_DEBUG = $(ASM_SRCS:%.s=obj/%-debug.o) $(C_SRCS:%.c=obj/%-debug.o)

obj/%.o: %.s
	as6502 --core=65c02 --target=cx16 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%.o: %.c
	cc6502 --core=65c02 --target=cx16 -O2 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.s
	as6502 --core=65c02 --target=cx16 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.c
	cc6502 --core=65c02 --target=cx16 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

hello.prg:  $(OBJS)
	ln6502 --target=cx16 --core=65c02 cx16-plain.scm -o $@ $^  --output-format=prg --list-file=hello-cx16.lst

hello.elf: $(OBJS_DEBUG)
	ln6502 --target=x16 --core=65c02 cx16-plain.scm --debug -o $@ $^ --list-file=hello-debug.lst --semi-hosted

clean:
	-rm $(OBJS) $(OBJS:%.o=%.lst) $(OBJS_DEBUG) $(OBJS_DEBUG:%.o=%.lst)
	-rm hello.elf hello.prg hello-cx16.lst hello-debug.lst
