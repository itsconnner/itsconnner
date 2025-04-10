#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Redirecting user directories ... Skipped'
	exit
fi

cd

if [[ ! -h Desktop ]]; then
	rm -rf Desktop
fi
ln -snf /tmp desktop

rm -rf Documents

if [[ ! -h Downloads ]]; then
	rm -rf Downloads
fi
ln -snf /tmp download

rm -rf Music

rm -rf Pictures
mkdir -p picture/Screenshots
ln -snf picture/Screenshots screenshot

rm -rf Videos

xdg-user-dirs-update --set DESKTOP $HOME/desktop
xdg-user-dirs-update --set DOWNLOAD $HOME/download
xdg-user-dirs-update --set PICTURES $HOME/picture

setup_done
log 'Redirecting user directories ... OK'
