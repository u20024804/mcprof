PIN_DIR?=$(PIN_HOME)
MCPROF_DIR?=../..

CC = gcc
EXEC=exec
CMD=./$(EXEC)
CFLAGS=-O2
INCS=-I.
LDFLAGS=-L.
LIBS=-lvectOps -lm

SRCS = main.c
OBJS=$(SRCS:.c=.o)

all: clean $(EXEC)
$(EXEC):  $(OBJS)
	$(CC) -c -Wall -Werror -fPIC vectOps.c
	$(CC) -shared -o libvectOps.so vectOps.o
	$(CC) $(LDFLAGS) -o $(EXEC) $^ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCS) -c -o $@ $<

run: $(EXEC)
	$(CMD)

MCPROF_OPT:=-RecordStack 0  -TrackObjects 1 -Engine 1 -MainExecOnly 0
mcprof: CFLAGS=-Og -g -fno-inline -fdata-sections -ffunction-sections -fno-omit-frame-pointer
mcprof: LDFLAGS+=-Wl,--gc-sections
mcprof: clean $(EXEC)
	$(PIN_DIR)/pin -t $(MCPROF_DIR)/obj-intel64/mcprof.so $(MCPROF_OPT) -- $(CMD)

clean:
	rm -f *.o $(EXEC) $(OBJS) *~ *.log gmon.out libvectOps.so *.dot *.pdf callgraph.json \
		execProfile.dat locations.dat matrix.dat memProfile.dat recursivefunctions.dat \
		symbols.dat taskdependences.dat taskgraph.dat traces.dat

.PHONY: clean all run mcprof
