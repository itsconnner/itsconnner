#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && [[ $(which gcc) == $HOME* ]]; then
	log 'Compiling GCC ... Skipped'
	exit
fi

if virt; then
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 99
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 99

	log 'Linking GCC ... OK'
	exit
fi

url=$(cat $CONFIG_ROOT/gcc-url)

mkdir -p ~/git
cd ~/git

if [ ! -d gcc ]; then
	git clone $url
fi

cd gcc
git checkout releases/gcc-14.2.0

./contrib/download_prerequisites

mkdir -p build
cd build

if [[ -f Makefile ]]; then
	make distclean
fi

CC=gcc-14 CXX=g++-14 ../configure --disable-multilib --prefix=$HOME/.local

retry=0

while true; do
	make -j BOOT_CFLAGS='-O2' bootstrap

	if [[ $? -eq 0 ]]; then
		break;
	fi

	(( retry += 1 ))

	if [[ $retry -gt 5 ]]; then
		die 'too many errors during GCC compilation'
	fi
done

make install

log 'Compiling GCC ... OK'
