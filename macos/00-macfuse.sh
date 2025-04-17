#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing macfuse ... Skipped'
	exit
fi

if ! confirm 'enable reduced security policy for kernel extension?'; then
	note 'apply reduced security policy first'
	tail -f /dev/null &
	wait $!
fi

url=https://github.com/macfuse/macfuse/releases/download/macfuse-4.10.1/macfuse-4.10.1.dmg
name=$(basename $url)

curl -Lo $name $url
trap 'rm $name; exit' EXIT

setup_done
log 'Installing rclone ... INCOMPLETE'

note "Restart after manually installing '$name' and
      granting the necessary permission in Privacy & Security"

tail -f /dev/null &
wait $!
