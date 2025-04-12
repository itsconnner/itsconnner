#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Redirecting user directories ... Skipped'
	exit
fi

cd

cat <<EOF | sudo tee /etc/tmpfiles.d/user-dir.conf
d	/tmp/desktop	0700	$USER	$USER	-
d	/tmp/download	0700	$USER	$USER	-
d	/tmp/sandbox	0700	$USER	$USER	-

e!	/tmp/desktop	-	-	-	0
e!	/tmp/download	-	-	-	0
e!	/tmp/sandbox	-	-	-	0
EOF

sudo systemd-tmpfiles --create

if [[ ! -h Desktop ]]; then
	rm -rf Desktop
fi
ln -snf /tmp/desktop desktop

if [[ ! -h Downloads ]]; then
	rm -rf Downloads
fi
ln -snf /tmp/download download

ln -snf /tmp/sandbox sandbox

rm -rf Documents
rm -rf Music
rm -rf Videos

rm -rf Pictures
mkdir -p picture/Screenshots
ln -snf picture/Screenshots screenshot

xdg-user-dirs-update --set DESKTOP $HOME/desktop
xdg-user-dirs-update --set DOWNLOAD $HOME/download
xdg-user-dirs-update --set PICTURES $HOME/picture

setup_done
log 'Redirecting user directories ... OK'
