#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring Zsh key bindings ... Skipped'
	exit
fi

touch ~/.zshrc

while read line; do
	if [[ ! $line || $line = '#'* ]]; then
		continue
	fi

	if grep -Fxq "$line" ~/.zshrc; then
		continue
	fi

	printf '\n%s\n' "$line" >> ~/.zshrc

done < $CONFIG_ROOT/zsh-key-binding

setup_done
log 'Configuring Zsh key bindings ... OK'
