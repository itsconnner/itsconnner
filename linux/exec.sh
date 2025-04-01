#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

export SCRIPT_PATH=$1
export SCRIPT_ROOT=$(dirname $0)
export CONFIG_ROOT=$SCRIPT_ROOT/../config
export LIBKIT_ROOT=$(dirname $(readlink -f $0))

function datadir()
{
	printf %s $HOME/.local/share/barroit
}

mkdir -p $(datadir)

source $LIBKIT_ROOT/libkit.sh
source $LIBKIT_ROOT/libsetup.sh

source $1
