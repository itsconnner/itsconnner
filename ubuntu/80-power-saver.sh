#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Setting power saver ... Skipped'
	exit
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
log 'Setting power mode ... OK'
