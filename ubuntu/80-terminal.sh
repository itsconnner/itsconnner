#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done || virt; then
	log 'Configuring GNOME Terminal ... Skipped'
	exit
fi

dconf load /org/gnome/terminal/legacy/profiles:/ < $CONFIG_ROOT/gnome-terminal

setup_done
log 'Configuring GNOME Terminal ... OK'
