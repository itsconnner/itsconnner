#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Aliasing commands ... Skipped'
	exit
fi

touch ~/.zshrc
touch ~/.zsh_aliases

while read line; do
	if [[ ! $line || $line == '#'* ]]; then
		continue
	fi

	name=$(r1 "$line")
	cmd=$(r2 "$line")
	prefix="alias $name"

	if grep -q "$prefix=" ~/.zsh_aliases; then
		sed -i '' "s|^$prefix='.*'$|$prefix='$cmd'|" ~/.zsh_aliases
	else
		printf '\n%s\n' "$prefix='$cmd'" >> ~/.zsh_aliases
	fi
done < $CONFIG_ROOT/cmd-alias

read -d '' lines <<EOF
if [ -f ~/.zsh_aliases ]; then
	. ~/.zsh_aliases
fi
EOF

if ! grep -Fxq "$lines" ~/.zshrc; then
	printf '\n%s\n' "$lines" >> ~/.zshrc
fi

setup_done
log 'Aliasing commands ... OK'
