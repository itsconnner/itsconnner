#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

while read; do
	umount $REPLY
done < <(mount | grep rclone | awk '{ print $3 }')
