#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done || virt; then
	log "Installing JetBrains Mono ... Skipped"
	exit
fi

url=$(cat $CONFIG_ROOT/jb-mono-url)
zip=$(basename $url)

tmp=$(mktemp -d)
dst=~/.local/share/fonts/jetbrains-mono

trap 'rm -rf "$tmp"' EXIT

cd $tmp

curl -L -o $zip $url
unzip $zip

rm -rf $dst
mv fonts $dst

fc-cache -f

setup_done
log "Installing JetBrains Mono ... OK"
