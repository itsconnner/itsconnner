#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Linking configuration files ... Skipped'
	exit
fi

while read line; do
	if [[ -z "$line" ]]; then
		continue
	fi

	name=$(r1 "$line")
	dst_dir=$(eval "printf %s \"$(r2 "$line")\"")
	mode=$(r3 "$line")

	src=$ASSETS_ROOT/$name
	dst=$dst_dir/$(basename $name)
	cmd='ln -sf'

	if printf %s $mode | grep -q copy; then
		cmd=cp
	fi

	if printf %s $mode | grep -q sudo; then
		cmd="sudo $cmd"
	fi

	mkdir -p $dst_dir

	$cmd $src $dst

	if [[ $? -eq 1 ]]; then
		fmt="${CYAN}%-25s${RESET} -> ${RED}%s${RESET}\n"
	else
		fmt="${CYAN}%-25s${RESET} -> ${GREEN}%s${RESET}\n"
	fi

	printf "$fmt" $name $dst

done < $CONFIG_ROOT/file-map

setup_done
log 'Linking configuration files ... OK'
