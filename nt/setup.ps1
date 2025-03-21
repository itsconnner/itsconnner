# SPDX-License-Identifier: GPL-3.0-or-later

#requires -version 6

$scripts = Get-ChildItem -Name -Filter ??-*.ps1 $PSScriptRoot

foreach ($script in $scripts) {
	pwsh -Command ". $PSScriptRoot\libkit.ps1; & $PSScriptRoot\$script"

	if (-not $?) {
		warn "$PSScriptRoot\$script setup is not complete"
	}
}
