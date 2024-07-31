# SPDX-License-Identifier: GPL-3.0-only

escape()
{
	sed 's/[/]/\\&/g' <<< "$1"
}

parse_file()
{
	local cur=0
	local tot=$(wc -l < "$1")
	local prev=
	while :; do
		if [[ $prev ]]; then
			read comment rest <<< "$prev"
			prev=
		else
			if ! read comment rest; then
				break
			fi
			(( cur++ ))
		fi

		if [[ -z "$rest" ]]; then
			continue;
		fi

		if [[ ! "$rest" =~ ^\<BR\>(.+)\<BR\>(.+) ]]; then
			continue
		fi

		local field=${BASH_REMATCH[1]}
		local value=$(eval echo ${BASH_REMATCH[2]})

		if [[ $cur -eq $tot ]]; then
			# calibration of $cur and $tot is not necessary
			echo >> "$1"
		fi

		read
		(( cur++ ))

		sed -i "${cur}s/.*/$(escape "$field $value")/" "$1"
		if [[ ! $cur -lt $tot ]]; then
			break
		fi

		read
		(( cur++ ))

		if [[ ! $REPLY ]]; then
			continue
		fi

		sed -i "${cur}s/.*/\n$(escape "$REPLY")/" "$1"
		(( cur++ ))
		(( tot++ ))
		prev="$REPLY"
	done < "$1"
}

mkdir -p $ASSETLIST/backup
exit_on_error

lncnt=0
while read; do
	(( lncnt++ ))
	if skip_line "$REPLY"; then
		continue
	fi

	cols=$(echo $REPLY | wc -w)
	if [[ $cols != '2' && $cols != '3' ]]; then
		error "an invalid line was found at line $lncnt"
		continue
	fi

	read target path action <<< "$REPLY"

	if [[ ! -f "$ASSETLIST/$target" ]]; then
		error "target ‘$target’ does not exist"
		continue
	fi

	eval=
	sudo=
	if [[ -n "$action" ]]; then
		action="${action//,/ }"
		if find_word 'eval' $action; then
			eval=1
		fi

		if find_word 'sudo' $action; then
			sudo=1
		fi
	fi

	if [[ $path =~ ^'~' ]]; then
		path="$HOME/${path:2}"
	fi

	if [[ ${path:0-1} = '/' ]]; then
		path+=$target
	fi

	dir=$(dirname $path)
	if [[ ! -d $dir ]]; then
		if [[ -f $dir ]]; then
			error "‘$dir’ is a regular file (target ‘$target’)"
		elif [[ $sudo ]]; then
			sudo mkdir -p $dir
		else
			mkdir -p $dir
		fi
		if [[ $? -ne 0 ]]; then
			continue
		fi
	fi

	if [[ ! -h $path && -f $path ]]; then
		bak=$target~$(basename $path)
		if ! cp $path "$ASSETLIST/backup/$bak"; then
			warn "failed to back up ‘$path’ (target ‘$target’)"
			continue
		fi
	fi

	if [[ $sudo ]]; then
		sudo ln -sf "$PWD/$ASSETLIST/$target" $path
	else
		ln -sf "$PWD/$ASSETLIST/$target" $path
	fi
	if [[ $? -ne 0 ]]; then
		continue
	fi

	printf "${CYAN}%-25s${RESET} -> ${GREEN}%s${RESET}\n" "$target" "$path"

	if [[ $eval ]]; then
		parse_file "$ASSETLIST/$target"
	fi

done < "$CONFLIST/filelinks"
