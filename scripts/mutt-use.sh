#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

this=$(perl -e 'use Cwd "abs_path"; print abs_path(shift); "\n"' $0)
root=$(dirname $this)/..
alias=$1

. $root/posix/libkit.sh

if [ -z "$alias" ]; then
	die 'missing email address'
fi

case $alias in
*@*)
	config=$(find $root/assets/mutt -name $alias)
	;;
*)
	config=$(find $root/assets/mutt -name "$alias*@*" | sort)
	is_alias=1
esac

if [ -z "$config" ]; then
	if [ $is_alias ]; then
		die "unknown user name \`$alias'"
	else
		die "unknown email address \`$alias'"
	fi
fi

if [ $(printf '%s\n' "$config" | wc -l) -ne 1 ]; then
	lines=$(printf '%s\n' $config | xargs -n1 basename)
	lines=$(printf '\n  %s' $lines)

	die "ambiguous user name \`$alias'; could be:$lines"
fi

name=$(basename $config)
mutt=$(dirname $config)
mutt=$(perl -e 'use Cwd "abs_path"; print abs_path(shift); "\n"' $mutt)

current=$mutt/$name
client=$mutt/client.$name

ln -sf $current ~/.mutt/current
ln -sf $client ~/.mutt/client
