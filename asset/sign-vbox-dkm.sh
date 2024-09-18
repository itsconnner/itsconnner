#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-only
#
# tool for automation of sign virtualbox dynamic kernel modules

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

if [[ ! -f ~/.mok/virtualbox || ! -f ~/.mok/virtualbox.der ]]; then
	>&2 echo -e "${RED}error${RESET}: setup virtualbox mok first"
	exit 1
fi

dkms=/lib/modules/$(uname -r)/updates/dkms

sudo unzstd $dkms/vbox*.zst -qq

for ko in $(echo $dkms/vbox*.ko); do
	sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
	     ~/.mok/virtualbox ~/.mok/virtualbox.der $ko

	printf "${CYAN}%-15s${RESET} -> ${GREEN}signed${RESET}\n" \
	       "$(basename $ko)"
done

# sudo zstd -f --rm -qq $dkms/vbox*.ko
# need to keep a copy of that *.ko, some versions of 
# kernel do not recognize.ko.zst module files
sudo zstd -f -qq $dkms/vbox*.ko

for m in $(echo $dkms/vbox*.zst); do
	name=$(basename $m | sed 's/\..*$//')
	sudo modprobe -r $name
	sudo modprobe $name
done
