#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done || ! virt; then
	log 'Configuring ssh server ... Skipped'
	exit
fi

cd ~/.ssh

ssh-keygen -y -f id_lvm_noble > authorized_keys

cat <<EOF | sudo tee /etc/ssh/sshd_config.d/39-auth.conf
PasswordAuthentication no
EOF

sudo systemctl restart ssh.service

setup_done
log 'Configuring ssh server ... OK'
