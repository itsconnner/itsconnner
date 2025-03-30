#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

script_path=$(perl -e 'use Cwd "abs_path"; print abs_path(shift); "\n"' $0)
script_root=$(dirname $script_path)

. $script_root/../posix/libkit.sh

if [ ! "$(git diff VERSION)" ] &&
   [ ! "$(git diff --staged VERSION)" ] &&
   [ $(git ls-files VERSION) ]; then
	die 'no changes in VERSION'
fi

git add VERSION

name=$(cat NAME)
version=$(cat VERSION)

git commit -m "$name $version"

git tag -sm "$name $version" "v$version"
