#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring core dump ... Skipped'
	exit
fi

if systemctl status apport.service >/dev/null 2>&1; then
	sudo systemctl stop apport.service
	sudo systemctl disable apport.service
fi

printf '%s\n' 'kernel.core_uses_pid = 0' 'kernel.core_pattern = core.%e' |
sudo tee /etc/sysctl.d/39-coredump.conf

sudo service procps reload

setup_done
log 'Configuring core dump ... OK'
