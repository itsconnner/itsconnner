#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Copying private keys ... Skipped'
	exit
fi

secret=/Volumes/secret

if [[ ! -d $secret ]]; then
	die "GPG file storage didn't mount to \`$secret'"
fi

for file in $(ls $secret); do
	case $file in
	pg_*.gpg)
		if ! confirm "import $file?"; then
			continue
		fi

		gpg --import $secret/$file

		if [[ $? -ne 0 ]]; then
			error "Importing $file ... Failed"
			continue
		fi
		;;

	id_*.gpg)
		name=${file%.gpg}
		dst=~/.ssh/$name

		if ! confirm "decrypt $file to $HOME/.ssh?"; then
			log "Importing $name ... Skipped"
			continue
		fi

		gpg --yes -o $dst -d $secret/$file

		if [[ $? -ne 0 ]]; then
			error "Importing $name ... Failed"
			continue
		fi

		chmod 0600 $dst
		;;
	*)
		continue
	esac

	log "Importing ${name:-$file} ... DONE"
done

setup_done
log 'Copying private keys ... OK'
