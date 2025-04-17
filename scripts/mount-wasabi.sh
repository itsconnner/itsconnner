#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

mkdir -p $HOME/wasabi $HOME/cred

if ! mount | grep -q wasabi:barroit; then
	rclone mount --daemon wasabi:barroit $HOME/wasabi
fi

if ! mount | grep -q wasabi:cred; then
	rclone mount --daemon --vfs-cache-mode=full wasabi:cred $HOME/cred
fi
