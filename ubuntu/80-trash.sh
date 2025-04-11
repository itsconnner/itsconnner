#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring trash can ... Skipped'
	exit
fi

cat <<EOF > ~/.config/systemd/user/trash.service
[Unit]
After=default.target

[Service]
ExecStart=rm -rf %h/.local/share/Trash
Type=oneshot

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable ~/.config/systemd/user/trash.service

setup_done
log 'Configuring trash can ... OK'
