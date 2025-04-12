#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

export LIBKIT_ROOT=$(dirname $(readlink -f $0))/../linux
source $LIBKIT_ROOT/libkit.sh

if [[ ! -f ~/.mok/vmware || ! -f ~/.mok/vmware.der ]]; then
	error 'VMware Workstation MOKs are not found'

	if ! confirm "Enroll the keys?"; then
		warn "VMware Workstation kernel module signing was interrupted"
		exit 0
	fi

	if ! openssl version | grep -q '3\.'; then
		die 'missing 3.x openssl'
	fi

	openssl genpkey -out ~/.mok/vmware \
			-algorithm RSA -pkeyopt rsa_keygen_bits:4096

	openssl req -new -x509 -key ~/.mok/vmware \
		    -outform DER -out ~/.mok/vmware.der -days 36500

	sudo mokutil --import ~/.mok/vmware.der

	if ! confirm "Reboot now?"; then
		note "VMware Workstation kernel module signing is incomplete"
		exit 0
	fi

	sudo reboot
fi

for module in vmmon vmnet; do
	sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file \
	     sha256 ~/.mok/vmware ~/.mok/vmware.der $(modinfo -n $module)

	sudo modprobe -r $module
	sudo modprobe $module
done

log "Signing VMware Workstation kernel modules ... OK"
