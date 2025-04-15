#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing pipx packages ... Skipped'
	exit
fi

# 'which -s' behaves strange on macos
if ! which pipx >/dev/null; then
	die "can't find pipx in current environment"
fi

while read line; do
	if line_need_skip "$line"; then
		continue
	fi

	pipx install $line
done < $CONFIG_ROOT/pipx-packages

setup_done
log 'Installing pipx packages ... OK'
