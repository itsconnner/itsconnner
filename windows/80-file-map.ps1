# SPDX-License-Identifier: GPL-3.0-or-later
# NO MORE SYMLINKS ON WINDOWS. THE DEFAULT FILE SYSTEM FUCKED ME UP :(

$config = read-pair $PSScriptRoot\..\config\file-map

foreach ($line in (read-line $PSScriptRoot\..\config\file-map-windows)) {
	$col = $line -split '\t'
	$path = $col[0]

	$dir = ($config[$path] -split '\t')[0]
	$name = ($path -split '/')[1]

	if ($col.Count -gt 1) {
		$col = $col | Where-Object { $_ }
		$dir = $col[1]
	}

	$dir = Invoke-Expression "`"$($dir)`""

	if (-not (Test-Path $dir)) {
		New-Item -ItemType Directory $dir >NUL
	}

	$dst = "$(Resolve-Path $dir)\$name"

	Copy-Item -Force "$PSScriptRoot/../assets/$path" $dst

	$file = Get-Item -Force $dst

	$file.Attributes = $file.Attributes -band `
			   -bnot [System.IO.FileAttributes]::Hidden

	log ("$CYAN{0,-25}$RESET -> $GREEN$dst$RESET" -f $path)
}

log "Linking configuration files ... OK"
