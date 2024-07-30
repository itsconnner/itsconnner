# SPDX-License-Identifier: GPL-3.0-or-later

export COMMENT='#'
export SUPERUSER=
export IOTARGET="$HOME/.bash_aliases"

lncnt=0
while read name value; do
	(( lncnt++ ))
	if skip_line "$name"; then
		continue
	fi

	if [[ -z "$value" ]]; then
		error "an invalid line was found at line $lncnt, skipped"
		continue
	fi

	write_on_missing "alias $name='$value'"
done < "$CONFLIST/aliases"

export IOTARGET="$HOME/.bashrc"
  write_on_missing '. ~/.bash_aliases'
