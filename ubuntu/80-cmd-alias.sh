#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log "Aliasing commands ... Skipped"
	exit
fi

touch ~/.bash_aliases

while read line; do
	if [[ ! $line || $line == '#'* ]]; then
		continue
	fi

	name=$(r1 "$line")
	cmd=$(r2 "$line")
	prefix="alias $name"

	if grep -q $name ~/.bash_aliases; then
		sed -i "s|^$prefix='.*'$|$prefix='$cmd'|" ~/.bash_aliases
	else
		printf '\n%s\n' "$prefix='$cmd'" >> ~/.bash_aliases
	fi
done < $CONFIG_ROOT/cmd-alias

setup_done
log "Aliasing commands ... OK"
