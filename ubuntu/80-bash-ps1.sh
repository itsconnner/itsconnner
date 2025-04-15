#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring Bash PS1 ... Skipped'
	exit
fi

touch ~/.bashrc

line="PS1='\w \\$ '"

if ! grep -q "$line" ~/.bashrc; then
	printf '\n%s\n' "$line" >> ~/.bashrc
fi

setup_done
log 'Configuring Bash PS1 ... OK'
