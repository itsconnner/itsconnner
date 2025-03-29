# SPDX-License-Identifier: GPL-3.0-or-later

if [[ ! $KTREE ]]; then
	die 'missing kernel tree (set KTREE path by setting ‘KTREE’)'
elif [[ $(wc -w <<< "$KTREE") != '1' ]]; then
	die "path ‘$KTREE’ contains space"
elif [[ ! -d $KTREE ]]; then
	die "invalid KTREE path ‘$KTREE’"
fi

script="$KTREE/scripts"
ktool="$ABSGEN/ktool"

mkdir -p $ktool

COMMENT='#'
SUPERUSER=

IOTARGET=$ALIASES
while read file args; do
	if skip_line "$file"; then
		continue
	fi

	src="$script/$file"
	dest="$ktool/$file"

	if [[ -h $dest && $(readlink $dest) = $src ]]; then
		continue
	fi

	if ! ln -sf $src $dest; then
		continue
	fi

	name="$(echo $file | awk -F . '{ print $1 }')"
	sep="$(test -n "$args" && echo ' ')"

	printf -v text "alias %s='%s%s%s'" $name $file "$sep" "$args"
	write_on_missing "$text"

	echo_linked $src $dest
done < "$CONFLIST/ktools"

if [[ $ktool =~ ^"$HOME/"(.*) ]]; then
	ktool="\$HOME/${BASH_REMATCH[1]}"
fi

IOTARGET=$PROFILE
skipped=
  write_on_missing "PATH=\"$ktool:\$PATH\""
  if [[ ! $skipped ]]; then
	  note 're-login for changes to take effect'
  fi
