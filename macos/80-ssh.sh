#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring ssh server ... Skipped'
	exit
fi

sudo systemsetup -setremotelogin on

cd ~/.ssh

ssh-keygen -y -f id_dev_macos > authorized_keys

cat <<EOF | sudo tee /etc/ssh/sshd_config.d/39-auth.conf
UsePAM yes
KbdInteractiveAuthentication no
PasswordAuthentication no
EOF

sudo launchctl kickstart -k system/com.openssh.sshd

setup_done
log 'Configuring ssh server ... OK'
