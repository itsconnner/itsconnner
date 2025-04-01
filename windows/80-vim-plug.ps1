# SPDX-License-Identifier: GPL-3.0-or-later

$url = Get-Content $PSScriptRoot\..\config\vim-plug-url
$dir = '~\vimfiles\autoload'

if (-not (Test-Path $dir)) {
	New-Item -ItemType Directory $dir >NUL
}

$dir = Resolve-Path $dir
$path = "$dir\plug.vim"

if ((Test-Path $path) -and -not (sr_is_force $args)) {
	log 'Installing vim plug ... Skipped'
	exit
}

curl -o $path $url

log 'Installing vim plug ... OK'
