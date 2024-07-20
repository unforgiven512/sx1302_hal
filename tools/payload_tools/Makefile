### get external defined data

include ../../target.cfg


### constant symbols

ARCH ?=
CROSS_COMPILE ?=

CC ?= $(CROSS_COMPILE)gcc
CXX ?= $(CROSS_COMPILE)g++
AR ?= $(CROSS_COMPILE)ar

OPTLVL ?= 2
DBGLVL ?= 0
CSTD   ?= gnu11
CXXSTD ?= gnu++14


INCDIRS := -I. -I../../libtools/inc

DEFINES :=
PROJECT_DEFINES ?=

CFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)
CXXFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CXXSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)


### linking options

LIBS := -ltinymt32


### general build targets

all: payload_crc payload_diff payload_gen

clean:
	rm -f payload_crc payload_diff payload_gen
	rm -f *.o

install:
ifneq ($(strip $(TARGET_IP)),)
 ifneq ($(strip $(TARGET_DIR)),)
  ifneq ($(strip $(TARGET_USR)),)
	@echo "---- Copying payload tools files to $(TARGET_IP):$(TARGET_DIR)"
	@ssh $(TARGET_USR)@$(TARGET_IP) "mkdir -p $(TARGET_DIR)"
	@scp payload_crc $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
	@scp payload_diff $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
	@scp payload_gen $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
  else
	@echo "ERROR: TARGET_USR is not configured in target.cfg"
  endif
 else
	@echo "ERROR: TARGET_DIR is not configured in target.cfg"
 endif
else
	@echo "ERROR: TARGET_IP is not configured in target.cfg"
endif

install-local:
	install -d $(LOCAL_TARGET_DIR)
	install -m 755 payload_diff payload_crc payload_gen $(LOCAL_TARGET_DIR)


### rules

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@


### test programs

payload_crc: payload_crc.o
	$(CC) $(CFLAGS) -o $@ $^

payload_diff: payload_diff.o
	$(CC) $(CFLAGS) -o $@ $^

payload_gen: payload_gen.o
	$(CC) $(CFLAGS) -L../../libtools -o $@ $^ $(LIBS)
