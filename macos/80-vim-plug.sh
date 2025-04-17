#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Installing vim plug ... Skipped'
	exit
fi

dst=~/.vim/autoload/plug.vim

if [[ ! -f $dst ]]; then
	mkdir -p $(dirname $dst)
fi

curl -Lo $dst $(cat $CONFIG_ROOT/vim-plug-url)

setup_done
log 'Installing vim plug ... OK'
