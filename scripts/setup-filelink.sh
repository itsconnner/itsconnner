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

		if [[ "$rest" =~ ^\<BRNOTE\>(.+)\<BRNOTE\>$ && ! $2 ]]; then
			note "$(eval echo ${BASH_REMATCH[1]})"
			continue
		elif [[ ! "$rest" =~ ^\<BR\>(.+)\<BR\>(.+) ]]; then
			continue
		fi

		local fmt=${BASH_REMATCH[1]}
		local ap=$(eval echo ${BASH_REMATCH[2]})

		if [[ $cur -eq $tot ]]; then
			# calibration of $cur and $tot is not necessary
			echo >> "$1"
		fi

		read
		(( cur++ ))

		content=$(printf "$fmt" $ap)
		sed -i "${cur}s/.*/$(escape "$content")/" "$1"
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

BAKDIR="$ABSGEN/asset.bac"
mkdir -p $BAKDIR
exit_on_error

backup_file()
{
	local dest=$1
	local target=$2

	if ! cp $dest "$BAKDIR/$target~$(basename $dest)"; then
		warn "failed to back up ‘$dest’ (target ‘$target’)"
		return 1
	fi
}

initwr=1
link_file()
{
	local src=$1
	local dest=$2
	local target=$3
	local sudo=$4

	local dir=$(dirname $dest)
	if [[ ! -d $dir ]]; then
		if [[ -f $dir ]]; then
			error "‘$dir’ is a regular file (target ‘$target’)"
		elif [[ $sudo ]]; then
			sudo mkdir -p $dir
		else
			mkdir -p $dir
		fi
		if [[ $? -ne 0 ]]; then
			return 1
		fi
	fi

	if [[ ! -h $dest && -f $dest ]]; then
		backup_file $dest $target
	fi

	if [[ $sudo ]]; then
		sudo ln -sf $src $dest
	else
		ln -sf $src $dest
	fi
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	if [[ $initwr ]]; then
		echo_line_sep $CURSCR
		initwr=
	fi

	echo_linked $target $dest
}

copy_file()
{
	local src=$1
	local dest=$2
	local target=$3
	local sudo=$4

	if [[ ! -h $dest && -f $dest ]] && ! cmp -s $src $dest ; then
		backup_file $dest $target
	fi

	if [[ $sudo ]]; then
		sudo cp --remove-destination $src $dest
	else
		cp --remove-destination $src $dest
	fi
}

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

	read target dest action <<< "$REPLY"

	src="$PWD/$ASSETLIST/$target"
	if ! no_space $src; then
		error "src ‘$src’ contains space (target ‘$target’)"
		continue
	fi

	if [[ $action ]] && ! no_space $action; then
		error "action ‘$action’ contains space (target ‘$target’)"
		continue
	fi

	if [[ ! -f $src ]]; then
		error "target ‘$target’ does not exist"
		continue
	fi

	eval=
	sudo=
	copy=
	if [[ -n $action ]]; then
		action=${action//,/ }
		if find_word 'eval' $action; then
			eval=1
		fi

		if find_word 'sudo' $action; then
			sudo=1
		fi

		if find_word 'copy' $action; then
			copy=1
		fi
	fi

	if [[ $dest =~ ^'~' ]]; then
		dest=$HOME/${dest:2}
	fi

	if [[ ${dest:0-1} = '/' ]]; then
		dest+=$target
	fi

	skip_ln=
	is_copy=
	if [[ $copy ]]; then
		is_copy=1
	elif [[ -h $dest && $(readlink $dest) = $src ]]; then
		if [[ ! $eval ]]; then
			continue
		else
			skip_ln=1
		fi
	fi

	if [[ ! $skip_ln && ! $is_copy ]]; then
		link_file $src $dest $target $sudo
		if [[ $? -ne 0 ]]; then
			continue
		fi
	fi

	if [[ $eval ]]; then
		parse_file $src $skip_ln
	fi

	if [[ $is_copy ]]; then
		copy_file $src $dest $target $sudo
	fi
done < "$CONFLIST/filelinks"
