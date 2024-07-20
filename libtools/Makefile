### get external defined data

### constant symbols

ARCH ?=
CROSS_COMPILE ?=
CC ?= $(CROSS_COMPILE)gcc
CXX ?= $(CROSS_COMPILE)g++
AR := $(CROSS_COMPILE)ar

OPTLVL ?= 2
DBGLVL ?= 0
CSTD   ?= gnu11
CXXSTD ?= gnu++14


INCDIRS := -Iinc -I.

DEFINES :=
PROJECT_DEFINES ?=

CFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)
CXXFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CXXSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)


OBJDIR = obj
INCLUDES = $(wildcard inc/*.h)

### linking options

### general build targets

all: libtinymt32.a libparson.a libbase64.a

clean:
	rm -f libtinymt32.a
	rm -f libparson.a
	rm -f libbase64.a
	rm -f $(OBJDIR)/*.o

### library module target

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: src/%.c $(INCLUDES) | $(OBJDIR)
	$(CC) -c $(CFLAGS) $< -o $@

### static library

libtinymt32.a:  $(OBJDIR)/tinymt32.o
	$(AR) rcs $@ $^

libparson.a:  $(OBJDIR)/parson.o
	$(AR) rcs $@ $^

libbase64.a:  $(OBJDIR)/base64.o
	$(AR) rcs $@ $^

### test programs

### EOF
