	 / _____)             _              | |
	( (____  _____ ____ _| |_ _____  ____| |__
	 \____ \| ___ |    (_   _) ___ |/ ___)  _ \
	 _____) ) ____| | | || |_| ____( (___| | | |
	(______/|_____)_|_|_| \__)_____)\____)_| |_|
	  (C)2019 Semtech

How to auto-start the with systemd
==================================

## Create a new systemd service ##

Update the `lora_pkt_fwd.service` file with proper paths and options, then

```console
sudo cp lora_pkt_fwd.service /etc/systemd/system
```


### Enable the service for autostart with ###

To enable the service for autostart on next system boot:

```console
sudo systemctl daemon-reload
sudo systemctl enable lora_pkt_fwd.service
sudo reboot
```

To enable the service for autostart on next system boot, as well as immediately start the service:

```console
sudo systemctl daemon-reload
sudo systemctl enable --now lora_pkt_fwd.service
```


### The following commands to disable the service, manually start/stop it: ###

```console
sudo systemctl disable lora_pkt_fwd.service
```

```console
sudo systemctl start lora_pkt_fwd.service
```

```console
sudo systemctl stop lora_pkt_fwd.service
```


## (DEPRECATED) Configure rsyslog to redirect the packet forwarder logs into a dedicated file ##

```console
sudo cp lora_pkt_fwd.conf /etc/rsyslog.d
sudo systemctl restart rsyslog
```

### See the logs ###

To view the logs from the **systemd journal**:

```console
sudo journalctl -u lora_pkt_fwd -f
```

or, to view the logs written by the `rsyslog` daemon _(**NOTE**: this method is deprecated)_:

```console
cat /var/log/lora_pkt_fwd.log
```
