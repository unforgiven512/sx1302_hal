### get external defined data

LIBLORAGW_VERSION := `cat ../VERSION`
include library.cfg
include ../target.cfg


### constant symbols

ARCH ?=
CROSS_COMPILE ?=
CC      ?= $(CROSS_COMPILE)gcc
CXX     ?= $(CROSS_COMPILE)g++
AR      ?= $(CROSS_COMPILE)ar
LD      ?= $(CROSS_CONPILE)ld
AS      ?= $(CROSS_COMPILE)as
OBJCOPY ?= $(CROSS_COMPILE)objcopy
OBJDUMP ?= $(CROSS_COMPILE)objdump
NM      ?= $(CROSS_COMPILE)nm
SIZE    ?= $(CROSS_COMPILE)size
ECHO    ?= echo
INSTALL ?= install
MKDIR   ?= mkdir
CP      ?= cp
MV      ?= mv
RM      ?= rm


OPTLVL ?= 2
DBGLVL ?= 0
CSTD   ?= gnu11
CXXSTD ?= gnu++14


INCDIRS := -Iinc -I. -I../libtools/inc

DEFINES := -DHAL_DISABLE_TEMP_SENSOR=0
PROJECT_DEFINES ?=

CFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)
CXXFLAGS := -O$(OPTLVL) -g$(DBGLVL) -Wall -Wextra -std=$(CXXSTD) $(DEFINES) $(PROJECT_DEFINES) $(INCDIRS)

OBJDIR := obj
INCLUDES := $(wildcard inc/*.h) $(wildcard ../libtools/inc/*.h)


### linking options

LIBS := -lloragw -ltinymt32 -lrt -lm


### general build targets

all: 	libloragw.a \
		test_loragw_com \
		test_loragw_i2c \
		test_loragw_reg \
		test_loragw_hal_tx \
		test_loragw_hal_rx \
		test_loragw_cal_sx125x \
		test_loragw_capture_ram \
		test_loragw_com_sx1250 \
		test_loragw_com_sx1261 \
		test_loragw_counter \
		test_loragw_gps \
		test_loragw_toa \
		test_loragw_sx1261_rssi

clean:
	rm -f libloragw.a
	rm -f test_loragw_*
	rm -f $(OBJDIR)/*.o
	rm -f inc/config.h
	rm -f ../tools/reset_lgw.sh

install:
ifneq ($(strip $(TARGET_IP)),)
 ifneq ($(strip $(TARGET_DIR)),)
  ifneq ($(strip $(TARGET_USR)),)
	$(ECHO) "---- Copying libloragw files to $(TARGET_IP):$(TARGET_DIR)"
	@ssh $(TARGET_USR)@$(TARGET_IP) "mkdir -p $(TARGET_DIR)"
	@scp test_loragw_* $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
	@scp ../tools/reset_lgw.sh $(TARGET_USR)@$(TARGET_IP):$(TARGET_DIR)
  else
	$(ECHO) "ERROR: TARGET_USR is not configured in target.cfg"
  endif
 else
	$(ECHO) "ERROR: TARGET_DIR is not configured in target.cfg"
 endif
else
	$(ECHO) "ERROR: TARGET_IP is not configured in target.cfg"
endif

install-local:
	$(INSTALL) -d $(LOCAL_TARGET_DIR)
	$(INSTALL) -d $(LOCAL_CONFIG_DIR)
	$(INSTALL) -m 755 test_loragw_* $(LOCAL_TARGET_DIR)
	@sed 's~@@TARGET_DIR@@~'$(LOCAL_TARGET_DIR)'~' ../tools/reset_lgw.sh.in > ../tools/reset_lgw.sh
	$(INSTALL) -m 755 ../tools/reset_lgw.sh $(LOCAL_TARGET_DIR)
	$(INSTALL) -m 644 ../tools/lgw_gpio.cfg.sample $(LOCAL_CONFIG_DIR)
	#$(INSTALL) -m 644 ../tools/lgw_gpio.cfg.sample $(LOCAL_CONFIG_DIR)/lgw_gpio.cfg
	@ln -sf $(LOCAL_CONFIG_DIR)/lgw_gpio.cfg $(LOCAL_TARGET_DIR)/lgw_gpio.cfg
	$(ECHO) "---[ Copy $(LOCAL_CONFIG_DIR)/lgw_gpio.cfg.sample to lgw_gpio.cfg and edit as needed ]---"


### transpose library.cfg into a C header file : config.h

inc/config.h: ../VERSION library.cfg
	$(ECHO) "*** Checking libloragw library configuration ***"
	$(RM) -f $@
	# File initialization
	$(ECHO) "#ifndef LORAGW_CONFIGURATION_H_" >> $@
	$(ECHO) "#define LORAGW_CONFIGURATION_H_\n\n" >> $@
	# Release version
	$(ECHO) "Release version   : $(LIBLORAGW_VERSION)"
	$(ECHO) "#define LIBLORAGW_VERSION	"\"$(LIBLORAGW_VERSION)\""" >> $@
	# Debug options
	$(ECHO) "\n#define DEBUG_AUX		$(DEBUG_AUX)" >> $@
	$(ECHO) "#define DEBUG_COM		$(DEBUG_COM)" >> $@
	$(ECHO) "#define DEBUG_MCU		$(DEBUG_MCU)" >> $@
	$(ECHO) "#define DEBUG_I2C		$(DEBUG_I2C)" >> $@
	$(ECHO) "#define DEBUG_REG		$(DEBUG_REG)" >> $@
	$(ECHO) "#define DEBUG_HAL		$(DEBUG_HAL)" >> $@
	$(ECHO) "#define DEBUG_GPS		$(DEBUG_GPS)" >> $@
	$(ECHO) "#define DEBUG_GPIO		$(DEBUG_GPIO)" >> $@
	$(ECHO) "#define DEBUG_LBT		$(DEBUG_LBT)" >> $@
	$(ECHO) "#define DEBUG_RAD		$(DEBUG_RAD)" >> $@
	$(ECHO) "#define DEBUG_CAL		$(DEBUG_CAL)" >> $@
	$(ECHO) "#define DEBUG_SX1302	$(DEBUG_SX1302)" >> $@
	$(ECHO) "#define DEBUG_FTIME		$(DEBUG_FTIME)" >> $@
	# end of file
	$(ECHO) '\n\n#endif	/* !LORAGW_CONFIGURATION_H_ */' >> $@
	$(ECHO) "*** Configuration seems ok ***"


### library module target

$(OBJDIR):
	$(MKDIR) -p $(OBJDIR)

$(OBJDIR)/%.o: src/%.c $(INCLUDES) inc/config.h | $(OBJDIR)
	$(CC) -c $(CFLAGS) $< -o $@


### static library

libloragw.a: $(OBJDIR)/loragw_spi.o \
			 $(OBJDIR)/loragw_usb.o \
			 $(OBJDIR)/loragw_com.o \
			 $(OBJDIR)/loragw_mcu.o \
			 $(OBJDIR)/loragw_i2c.o \
			 $(OBJDIR)/sx125x_spi.o \
			 $(OBJDIR)/sx125x_com.o \
			 $(OBJDIR)/sx1250_spi.o \
			 $(OBJDIR)/sx1250_usb.o \
			 $(OBJDIR)/sx1250_com.o \
			 $(OBJDIR)/sx1261_spi.o \
			 $(OBJDIR)/sx1261_usb.o \
			 $(OBJDIR)/sx1261_com.o \
			 $(OBJDIR)/loragw_aux.o \
			 $(OBJDIR)/loragw_reg.o \
			 $(OBJDIR)/loragw_sx1250.o \
			 $(OBJDIR)/loragw_sx1261.o \
			 $(OBJDIR)/loragw_sx125x.o \
			 $(OBJDIR)/loragw_sx1302.o \
			 $(OBJDIR)/loragw_cal.o \
			 $(OBJDIR)/loragw_debug.o \
			 $(OBJDIR)/loragw_hal.o \
			 $(OBJDIR)/loragw_lbt.o \
			 $(OBJDIR)/loragw_stts751.o \
			 $(OBJDIR)/loragw_gps.o \
			 $(OBJDIR)/loragw_sx1302_timestamp.o \
			 $(OBJDIR)/loragw_sx1302_rx.o \
			 $(OBJDIR)/loragw_ad5338r.o
	$(AR) rcs $@ $^


### test programs

test_loragw_com: tst/test_loragw_com.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools $< -o $@ $(LIBS)

test_loragw_i2c: tst/test_loragw_i2c.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools $< -o $@ $(LIBS)

test_loragw_reg: tst/test_loragw_reg.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools $< -o $@ $(LIBS)

test_loragw_hal_tx: tst/test_loragw_hal_tx.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools $< -o $@ $(LIBS)

test_loragw_hal_rx: tst/test_loragw_hal_rx.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools $< -o $@ $(LIBS)

test_loragw_capture_ram: tst/test_loragw_capture_ram.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_cal_sx125x: tst/test_loragw_cal_sx125x.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_com_sx1250: tst/test_loragw_com_sx1250.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_com_sx1261: tst/test_loragw_com_sx1261.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_counter: tst/test_loragw_counter.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_gps: tst/test_loragw_gps.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_toa: tst/test_loragw_toa.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

test_loragw_sx1261_rssi: tst/test_loragw_sx1261_rssi.c libloragw.a
	$(CC) $(CFLAGS) -L. -L../libtools  $< -o $@ $(LIBS)

