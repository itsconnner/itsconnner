#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Adjusting power mode ... Skipped'
	exit
fi

if ! virt; then
	powerprofilesctl set power-saver
else
	powerprofilesctl set performance
fi

type=desk
power=ac

if laptop; then
	type=lap
	power=battery
fi

blank=$(v1 $CONFIG_ROOT/power-mode ${type}_blank)
suspend=$(v1 $CONFIG_ROOT/power-mode ${type}_suspend)

gsettings set org.gnome.desktop.session idle-delay $blank

gsettings set org.gnome.settings-daemon.plugins.power \
	  sleep-inactive-$power-timeout $(( $suspend * 60))

gsettings set org.gnome.settings-daemon.plugins.power \
	  sleep-inactive-$power-type 'suspend'

setup_done
log 'Adjusting power mode ... OK'
