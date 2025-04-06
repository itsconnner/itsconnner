#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! virt; then
	powerprofilesctl set power-saver
else
	powerprofilesctl set performance
fi

log 'Adjusting power mode ... OK'
