#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

if mount | grep -q wasabi:barroit; then
	umount $HOME/wasabi
fi

if mount | grep -q wasabi:cred; then
	umount $HOME/cred
fi
