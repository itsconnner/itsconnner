#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring Zsh history ... Skipped'
	exit
fi

line='setopt HIST_IGNORE_DUPS'

touch ~/.zshrc

if ! grep -Fq "$line" ~/.zshrc; then
	printf '\n%s\n' "$line" >> ~/.zshrc
fi

setup_done
log 'Configuring Zsh history ... OK'
