#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later
# darconf stands for Darwin configuration

root=$(dirname $(readlink -f $0))/..

cd $root

git fetch origin macos

if ! git worktree list | grep -q barroit-macos; then
	git worktree add ../barroit-macos macos
fi

line=$(grep code/settings.json $root/config/file-map-macos)
dst=$(printf '%s\n' "$line" | awk -F'\t+' '{print $2}')

dst=$(eval "printf '%s\n' \"$dst\"")
src=$(realpath ../barroit-macos)/assets/code/settings.json

ln -sf $src $dst
