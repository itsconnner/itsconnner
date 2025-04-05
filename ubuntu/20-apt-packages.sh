#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing apt packages ... Skipped'
	exit
fi

sudo apt update

while read line; do
	name=$(r1 "$line")
	type=$(r2 "$line")

	case $type in
	'd')
		if virt; then
			continue
		fi
		;;
	'v')
		if ! virt; then
			continue
		fi
	esac

	sudo apt install -y $name
done < $CONFIG_ROOT/apt-packages

setup_done
log 'Installing apt packages ... OK'
