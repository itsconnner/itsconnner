#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later

setup_is_done()
{
	touch $(datadir)/done

	grep -q $SCRIPT_PATH $(datadir)/done
}

setup_done()
{
	if ! setup_is_done; then
		printf '%s\n' $SCRIPT_PATH >> $(datadir)/done
	fi
}

exec_is_foce()
{
	test $SCRIPT_PATH = "$FORCE_EXEC"
}
