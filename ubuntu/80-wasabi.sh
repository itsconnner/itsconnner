#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring Wasabi cloud storage ... Skipped'
	exit
fi

sysd=$HOME/.config/systemd/user
secret=/media/$(whoami)/secret

if [[ ! -d $secret ]]; then
	die "GPG file storage didn't mount to \`$secret'"
fi

mkdir -p $HOME/.config/rclone
gpg --yes -o $HOME/.config/rclone/rclone.conf -d $secret/rclone.conf.gpg

if [[ $? -ne 0 ]]; then
	die "Importing rclone.conf ... Failed"
fi

mkdir -p $sysd

cat <<EOF > $sysd/wasabi.service
[Unit]
After=default.target

[Service]
ExecStart=%h/git/barroit/scripts/mount-wasabi.sh
ExecStop=%h/git/barroit/scripts/unmount-wasabi.sh
RemainAfterExit=yes
Type=oneshot

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable $sysd/wasabi.service

$CONFIG_ROOT/../scripts/mount-wasabi.sh

setup_done
log 'Configuring Wasabi cloud storage ... OK'
