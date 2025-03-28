# SPDX-License-Identifier: GPL-3.0-or-later

#requires -version 7

param([ArgumentCompletions('dump', 'cmp')]
      [string]$action)

. $PSScriptRoot\..\windows\libkit.ps1

if (-not $action) {
	die "missing action, available actions are:`n  dump`n  cmp"
}

switch ($action) {
'dump' {
	reg query $args[0] 2>&1 >nul

	if (-not $?) {
		die "invalid registry path ``$($args[0])'"
	}

	if (Test-Path .redump) {
		Move-Item -Force .redump .redump.old
	}

	reg export $args[0] .redump
}
'cmp' {
	if (-not (Test-Path .redump.old)) {
		die 'not enough redumps to compare'
	}

	$new = Get-Content .redump
	$old = Get-Content .redump.old

	Compare-Object $new $old
}
}
