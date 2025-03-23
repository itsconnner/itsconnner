#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

BOLD='\033[1m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'
CYAN='\033[36m'
WHITE='\033[37m'
RESET='\033[0m'

die()
{
	>&2 echo -en "${BOLD}${RED}fatal:${RESET} "
	>&2 echo $@
	exit 128
}

error()
{
	>&2 echo -en "${BOLD}${RED}error:${RESET} "
	>&2 echo $@
	return 1
}

warn()
{
	>&2 echo -en "${BOLD}${YELLOW}warning:${RESET} "
	>&2 echo $@
	return 1
}

note()
{
	echo -en "${BOLD}${CYAN}note:${RESET} "
	echo $@
}

log()
{
	echo -en "${BOLD}${GREEN}[$(cut -d' ' -f2 /proc/uptime)]${RESET} "
	echo $@
}

confirm()
{
	>&2 printf "$1 [y/N] "
	read -n1 -s yn
	echo

	case $yn in
	[yY][eE][sS] | [yY])
		return 0
		;;
	*)
		return 1
		;;
	esac
}
