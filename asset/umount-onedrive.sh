#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

if [[ ! $ONESHOT_LIST ]]; then
	exit 0
fi

while read; do
	umount $REPLY
	rm -f "$ONESHOT_LIST/onedrive~$(basename $REPLY)"
done < <(mount | grep rclone | awk '{ print $3 }')
