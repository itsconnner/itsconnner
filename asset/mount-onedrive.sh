#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BG_BLACK='\033[40m'
RESET='\033[0m'

die()
{
	>&2 echo -e "${RED}fatal${RESET}: $*"
	exit 128
}

warn()
{
	>&2 echo -e "${YELLOW}warning${RESET}: $*"
	return 1
}

error()
{
	>&2 echo -e "${RED}error${RESET}: $*"
	return 1
}

report_link_success()
{
	printf "${CYAN}%-20s${RESET} -> ${GREEN}%s${RESET}\n" "$1" "$2"
}

report_link_failure()
{
	>&2 printf "${CYAN}%-20s${RESET} -> ${RED}${BG_BLACK}%s${RESET}\n" \
		   "$1" "$2"
}

if [[ ! $REMOTE_FILESYS ]]; then
	die 'run make setup-onedrive.sh first'
fi

if [[ ! $ONESHOT_LIST ]]; then
	die 'run make setup-oneshot-exec.sh first'
fi

for dir in $(rclone lsf --dirs-only "$REMOTE_FILESYS:"); do
	ff="$ONESHOT_LIST/onedrive~$(basename $dir)"
	src="$REMOTE_FILESYS:$dir"
	dest="$HOME/$dir"

	if [[ -f $ff ]]; then
		error "$src has been mounted"
		continue
	fi

	if [[ ! -d $dest ]] && ! mkdir $dest; then
		continue
	fi

	if [[ -n "$(ls -A $dest)" ]]; then
		warn "$dest is not empty, clean it up? [y/N]"
		read -sN1 reply

		case $reply in
		[yY])
			rm -r "$dest/"*
			;;
		*)
			report_link_failure $src $dest
			continue
		esac
	fi

	if rclone mount $src $dest --vfs-cache-mode full --daemon; then
		report_link_success $src $dest
		touch $ff
	else
		report_link_failure $src $dest
	fi
done
