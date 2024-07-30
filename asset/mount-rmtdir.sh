#!/usr/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BG_BLACK='\033[40m'
RESET='\033[0m'

THIS_FILE=$(sed 's/\//~/g' <<< "${0:1}")

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

report_link_success()
{
	printf "${CYAN}%-20s${RESET} -> ${GREEN}%s${RESET}\n" "$1" "$2"
}

report_link_failure()
{
	>&2 printf "${RED}${BG_BLACK}%-20s${RESET} ->" \
		   "${RED}${BG_BLACK}%s${RESET}\n" "$1" "$2"
}

if [[ ! $REMOTE_FILESYS ]]; then
	die 'run ‘make setup-onedrive.sh’ first'
fi

if [[ ! $ONESHOT_LIST ]]; then
	die 'run ‘make setup-oneshot-exec.sh’ first'
fi

for dir in $(rclone lsf --dirs-only "$REMOTE_FILESYS:"); do
	ost="$ONESHOT_LIST/$THIS_FILE~$(basename $dir)"
	src="$REMOTE_FILESYS:$dir"

	if [[ -f "$ost" ]]; then
		warn "‘$src’ has been mounted"
		continue
	elif [[ $(wc -w <<< "$dir") != '1' ]]; then
		warn "‘$dir’ contains space"
		continue
	elif [[ $dir =~ ^'.' ]]; then
		continue
	fi

	dest="$HOME/$dir"
	if [[ ${dest:0-1} = '/' ]]; then
		dest=${dest%?}
	fi

	if [[ -n "$(ls -A $dest)" ]]; then
		echo -n "‘$dest’ is not empty, clean it up? [y/N] "
		read -sN1 reply
		echo

		case $reply in
		[yY])
			rm -r "$dest/"*
			;;
		*)
			report_link_failure "$src" "$dest"
			continue
		esac
	fi

	if rclone mount "$src" "$dest" --vfs-cache-mode full --daemon; then
		report_link_success "$src" "$dest"
		touch "$ost"
	else
		report_link_failure "$src" "$dest"
	fi
done
