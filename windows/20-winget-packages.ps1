# SPDX-License-Identifier: GPL-3.0-or-later

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Installing winget packages ... Skipped'
	exit
}

if (likely-vm) {
	$is_dev = 1
}

$lines = read-line $PSScriptRoot\..\config\winget-packages

foreach ($line in $lines) {
	$skip = 0
	$col = @($line -split '\t' | Where-Object {
		$_ -and $_ -notmatch '^#'
	})

	$name = $col[0]
	$args = $col[1]

	$args = @($args -split ',')

	foreach ($arg in $args) {
		switch ($arg) {
		'v' {
			if (-not $is_dev) {
				$skip = 1
			}
		}
		'd' {
			if ($is_dev) {
				$skip = 1
			}
		}
		default {
			$path = $arg
		}
		}
	}

	if ($skip) {
		continue
	}

	if ($path) {
		env-path-append (Invoke-Expression "`"$path`"")
	}

	winget install --id=$name
}

sr_done (script_name)
log 'Installing winget packages ... OK'
