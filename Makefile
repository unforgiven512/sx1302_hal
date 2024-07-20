### Environment constants

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
SED     ?= sed
LN      ?= ln
export

include target.cfg


### general build targets

.PHONY: all clean install install_conf libtools libloragw packet_forwarder util_net_downlink util_chip_id util_boot util_spectral_scan

all: libtools libloragw packet_forwarder util_net_downlink util_chip_id util_boot util_spectral_scan

libtools:
	$(MAKE) all -e -C $@

libloragw: libtools
	$(MAKE) all -e -C $@

packet_forwarder: libloragw
	$(MAKE) all -e -C $@

util_net_downlink: libtools
	$(MAKE) all -e -C $@

util_chip_id: libloragw
	$(MAKE) all -e -C $@

util_boot: libloragw
	$(MAKE) all -e -C $@

util_spectral_scan: libloragw
	$(MAKE) all -e -C $@

systemd:
	@sed 's~@@TARGET_DIR@@~'$(TARGET_DIR)'~' tools/systemd/lora_pkt_fwd.service.in > tools/systemd/lora_pkt_fwd.service.in2
	@sed 's~@@CONFIG_DIR@@~'$(CONFIG_DIR)'~' tools/systemd/lora_pkt_fwd.service.in2 > tools/systemd/lora_pkt_fwd.service.out

local-systemd:
	@sed 's~@@TARGET_DIR@@~'$(LOCAL_TARGET_DIR)'~' tools/systemd/lora_pkt_fwd.service.in > tools/systemd/lora_pkt_fwd.service.in2
	@sed 's~@@CONFIG_DIR@@~'$(LOCAL_CONFIG_DIR)'~' tools/systemd/lora_pkt_fwd.service.in2 > tools/systemd/lora_pkt_fwd.service.out

clean:
	$(MAKE) clean -e -C libtools
	$(MAKE) clean -e -C libloragw
	$(MAKE) clean -e -C packet_forwarder
	$(MAKE) clean -e -C util_net_downlink
	$(MAKE) clean -e -C util_chip_id
	$(MAKE) clean -e -C util_boot
	$(MAKE) clean -e -C util_spectral_scan
	$(RM) -f tools/systemd/lora_pkt_fwd.service.in2
	$(RM) -f tools/systemd/lora_pkt_fwd.service.out

install:
	$(MAKE) install -e -C libloragw
	$(MAKE) install -e -C packet_forwarder
	$(MAKE) install -e -C util_net_downlink
	$(MAKE) install -e -C util_chip_id
	$(MAKE) install -e -C util_boot
	$(MAKE) install -e -C util_spectral_scan

install-systemd:
ifneq ($(strip $(TARGET_IP)),)
 ifneq ($(strip $(TARGET_DIR)),)
  ifneq ($(strip $(TARGET_USR)),)
	$(ECHO) "---- Copying systemd service file to $(TARGET_IP):$(SYSTEMD_DIR)"
	@scp tools/systemd/lora_pkt_fwd.service.out $(TARGET_USR)@$(TARGET_IP):/tmp/lora_pkt_fwd.service
	@ssh $(TARGET_USR)@$(TARGET_IP) "sudo cp /tmp/lora_pkt_fwd.service $(SYSTEMD_DIR)/lora_pkt_fwd.service"
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
	$(MAKE) install-local -e -C libloragw
	$(MAKE) install-local -e -C packet_forwarder
	$(MAKE) install-local -e -C util_net_downlink
	$(MAKE) install-local -e -C util_chip_id
	$(MAKE) install-local -e -C util_boot
	$(MAKE) install-local -e -C util_spectral_scan

install_conf:
	$(MAKE) install_conf -e -C packet_forwarder

install-conf:
	$(MAKE) install_conf -e -C packet_forwarder

install-local-conf:
	$(MAKE) install-local-conf -e -C packet_forwarder

install-local-systemd:
	$(INSTALL) -d $(LOCAL_TARGET_DIR)
	$(INSTALL) -d $(LOCAL_CONFIG_DIR)
	$(INSTALL) -m 644 tools/systemd/lora_pkt_fwd.service.out $(LOCAL_SYSTEMD_DIR)/lora_pkt_fwd.service

