#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

this=$(perl -e 'use Cwd "abs_path"; print abs_path(shift); "\n"' $0)
root=$(dirname $this)/..

. $root/posix/libkit.sh
. $root/posix/libsetup.sh

if [ -z "$1" ]; then
	die 'missing merge source

usage: synckit.sh <source> [<remote>]'
fi

src=$1
rmt=${2:-$1}

git fetch $rmt

if ! git show-ref --verify -q refs/heads/$src; then
	git switch -c $src
else
	git switch $src
fi
git reset --hard $src/master

git switch master

if [ $(merge-base master $src) = $(git rev-parse $src) ]; then
	printf 'Already up to date\n'
	exit
fi

cat <<EOF > .git/MERGE_MSG.$$
Merge branch '$rmt'

This commit brings the state in sync with $rmt:
$(git show -s --format='%h ("%s")' $src)

Signed-off-by: $(git var GIT_AUTHOR_IDENT | cut -d' ' -f-3)
EOF

trap 'rm .git/MERGE_MSG.$$' EXIT

cp .git/MERGE_MSG.$$ .git/MERGE_MSG
if git merge --no-ff --no-commit --no-edit $src; then
	is_ff=1
elif [ -f .pickignore ]; then
	for file in $(cat .pickignore); do
		if [ -f $file ]; then
			git rm $file
		fi
	done
fi

if [ -f FIXLICENSE ]; then
	new=$(v2 FIXLICENSE new)
	old=$(v2 FIXLICENSE old)

	$root/scripts/fix-license.sh "$old" "$new"
fi

cp .git/MERGE_MSG.$$ .git/MERGE_MSG
if [ -z "$(git diff --name-only --diff-filter=U)" ] || [ $is_ff ]; then
	git add .
	git merge --continue
fi
