#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring Zsh PS1 ... Skipped'
	exit
fi

touch ~/.zshrc

line="PS1='%~ %# '"

if ! grep -q "$line" ~/.zshrc; then
	printf '\n%s\n' "$line" >> ~/.zshrc
fi

setup_done
log 'Configuring Zsh PS1 ... OK'
