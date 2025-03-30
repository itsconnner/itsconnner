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
	$col = $line -split '\t' | Where-Object { $_ }

	$type = $col[0]
	$name = $col[1]
	$path = $col[2]
	$args = $col[3]

	switch ($type) {
	'dev' {
		if (-not $is_dev) {
			continue
		}
	}
	'desk' {
		if ($is_dev) {
			continue
		}
	}
	}

	$opt_id = "--id=$name"

	if ($args) {
		$opt_custom = "--custom=`"$args`""
	}

	winget install $opt_id $opt_custom

	if ($path -and $path -ne '-') {
		env-path-append (Invoke-Expression "`"$path`"")
	}
}

sr_done (script_name)
log 'Installing winget packages ... OK'
