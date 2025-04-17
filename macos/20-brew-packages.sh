#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing homebrew packages ... Skipped'
	exit
fi

brew update
touch ~/.zshrc

while read line; do
	if [[ ! $line || $line == '#'* ]]; then
		continue
	fi

	name=$(r1 "$line")
	cask=$(r2 "$line")
	prefix=$(r3 "$line")

	if [[ $cask && $cask == 'cask' ]]; then
		brew install --cask $name
	else
		brew install $name
	fi

	if [[ $prefix ]]; then
		exp="export PATH=\"$prefix:\$PATH\""

		if ! grep -q "$exp" ~/.zshrc; then
			printf '\n%s\n' "$exp" >> ~/.zshrc
		fi
	fi
done < $CONFIG_ROOT/brew-packages

setup_done
log 'Installing homebrew packages ... OK'
