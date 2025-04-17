#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing rclone ... Skipped'
	exit
fi

curl https://rclone.org/install.sh | sudo bash

setup_done
log 'Installing rclone ... OK'
