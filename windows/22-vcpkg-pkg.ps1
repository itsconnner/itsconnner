# SPDX-License-Identifier: GPL-3.0-or-later

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Installing vcpkg packages ... Skipped'
	exit
}

if (likely-vm) {
	$is_dev = 1
}

$lines = read-line $PSScriptRoot\..\conf\vcpkg-packages

foreach ($line in $lines) {
	$col = $line -split '\t'

	$type = $col[0]
	$name = $col[1]

	if ($type -eq 'dev' -and -not $is_dev) {
		continue
	}

	# vcpkg install $name
}

$seg = vcpkg list $name | ForEach-Object { $_ -split ' ' }
$seg = $seg[0] -split ':'

$triplet = $seg[1]

setenv VCPKG_PACKAGE_PREFIX "$Env:VCPKG_PREFIX\installed\$triplet"

sr_done (script_name)
log 'Installing vcpkg packages ... OK'
