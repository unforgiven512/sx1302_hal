### get external defined data

include ../target.cfg


### Application-specific constants

APP_NAME := lora_pkt_fwd


### Environment constants

LGW_PATH ?= ../libloragw
LIB_PATH ?= ../libtools

ARCH ?=
CROSS_COMPILE ?=

OBJDIR = obj
INCLUDES = $(wildcard inc/*.h)


### External constant definitions
# must get library build option to know if mpsse must be linked or not

include $(LGW_PATH)/library.cfg
RELEASE_VERSION := `cat ../VERSION`

### Constant symbols

CC  ?= $(CROSS_COMPILE)gcc
CXX ?= $(CROSS_COMPILE)g++
AR  := $(CROSS_COMPILE)ar

OPTLVL ?= 2
DBGLVL ?= 0
CSTD   ?= gnu11
CXXSTD ?= gnu++14


INCDIRS := -Iinc -I. -I../libtools/inc

DEFINES :=
PROJECT_DEFINES ?=

CFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)
CXXFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CXXSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)

VFLAG := -D VERSION_STRING="\"$(RELEASE_VERSION)\""


### Constants for Lora concentrator HAL library
# List the library sub-modules that are used by the application

LGW_INC =
ifneq ($(wildcard $(LGW_PATH)/inc/config.h),)
	# only for HAL version 1.3 and beyond
	LGW_INC += $(LGW_PATH)/inc/config.h
endif
LGW_INC += $(LGW_PATH)/inc/loragw_hal.h


### Linking options

LIBS := -lloragw -ltinymt32 -lparson -lbase64 -lrt -lpthread -lm


### General build targets

all: $(APP_NAME)

clean:
	rm -f $(OBJDIR)/*.o
	rm -f $(APP_NAME)

ifneq ($(strip $(TARGET_IP)),)
 ifneq ($(strip $(TARGET_DIR)),)
  ifneq ($(strip $(TARGET_USR)),)
install:
	@echo "---- Copying packet_forwarder files to $(TARGET_IP):$(TARGET_DIR)"
	@ssh $(TARGET_USR)@$(TARGET_IP) "mkdir -p $(TARGET_DIR)"
	@scp lora_pkt_fwd $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
install_conf:
	@echo "---- Copying packet_forwarder conf files to $(TARGET_IP):$(TARGET_DIR)"
	@ssh $(TARGET_USR)@$(TARGET_IP) "mkdir -p $(TARGET_DIR)"
	@scp global_conf.json.sx1250.* $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
	@scp global_conf.json.sx1255.* $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
	@scp global_conf.json.sx1257.* $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
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
	install -m 755 lora_pkt_fwd $(LOCAL_TARGET_DIR)

install-local-conf:
	install -d $(LOCAL_CONFIG_DIR)
	install -m 644 global_conf.json.sx1250.* $(LOCAL_CONFIG_DIR)
	install -m 644 global_conf.json.sx1255.* $(LOCAL_CONFIG_DIR)
	install -m 644 global_conf.json.sx1257.* $(LOCAL_CONFIG_DIR)
	@ln -sf $(LOCAL_CONFIG_DIR)/global_conf.json $(LOCAL_TARGET_DIR)/global_conf.json


### Sub-modules compilation

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: src/%.c $(INCLUDES) | $(OBJDIR)
	$(CC) -c $(CFLAGS) -I$(LGW_PATH)/inc $< -o $@

### Main program compilation and assembly

$(OBJDIR)/$(APP_NAME).o: src/$(APP_NAME).c $(LGW_INC) $(INCLUDES) | $(OBJDIR)
	$(CC) -c $(CFLAGS) $(VFLAG) -I$(LGW_PATH)/inc $< -o $@

$(APP_NAME): $(OBJDIR)/$(APP_NAME).o $(LGW_PATH)/libloragw.a $(OBJDIR)/jitqueue.o
	$(CC) -L$(LGW_PATH) -L$(LIB_PATH) $< $(OBJDIR)/jitqueue.o -o $@ $(LIBS)

### EOF
