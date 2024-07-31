#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-only

RED='\033[0;31m'
YELLOW='\033[0;33m'
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

if [[ ! $ONESHOT_LIST ]]; then
	die 'run ‘setup-oneshot-exec.sh’ first'
fi

if [[ -f "$ONESHOT_LIST/$THIS_FILE" ]]; then
	warn "‘$(basename $0)’ is executed more than once"
	exit 128
fi

if [[ $DUMB_DISTRIB ]]; then
	xmodmap "$HOME/.Xmodmap"
fi

gnome-terminal --tab --working-directory="$HOME/workspase"

bash "$HOME/mount-remote-files"

touch "$ONESHOT_LIST/$THIS_FILE"
