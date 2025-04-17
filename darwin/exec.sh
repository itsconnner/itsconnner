#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

root_dir=$(dirname $0)/..

export SCRIPT_NAME=$1
export ASSETS_ROOT=$root_dir/assets
export SCRIPT_ROOT=$root_dir/scripts
export CONFIG_ROOT=$root_dir/config
export LIBKIT_ROOT=$(dirname $(readlink -f $0))

function datadir()
{
	printf %s "$HOME/Library/Application Support/barroit"
}

mkdir -p "$(datadir)"

source $LIBKIT_ROOT/libkit.sh
source $LIBKIT_ROOT/libsetup.sh

source $1
