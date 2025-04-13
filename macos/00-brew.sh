#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing Homebrew ... Skipped'
	exit
fi

url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

/bin/bash -c "$(curl -fsSL $url)"

if [[ $? -ne 0 ]]; then
	exit 128
fi

setup_done
log 'Installing Homebrew ... OK'
