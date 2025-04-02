#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Copying private keys ... Skipped'
	exit
fi

locker=/media/$(whoami)/LOCKER

if [[ ! -d $locker ]]; then
	die "LOCKER did not mount to \`$locker'"
fi

for file in $(ls $locker); do
	case $file in
	pg_*.gpg)
		gpg --import $locker/$file

		if [[ $? -ne 0 ]]; then
			warn "Importing $file ... Failed"
			continue
		fi
		;;

	id_*.gpg)
		name=${file%.gpg}
		dst=$HOME/.ssh/$name

		gpg -o $dst -d $locker/$file

		if [[ $? -ne 0 ]]; then
			error "Importing $file ... Failed"
			continue
		fi

		chmod 0600 $dst
	esac

	log "Importing $file ... DONE"
done

setup_done
log 'Copying private keys ... OK'
