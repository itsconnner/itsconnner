#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring perf permissions ... Skipped'
	exit
fi

printf '%s\n' 'kernel.perf_event_paranoid = -1' | \
sudo tee /etc/sysctl.d/39-perf.conf

sudo service procps reload

setup_done
log 'Configuring perf permissions ... OK'
