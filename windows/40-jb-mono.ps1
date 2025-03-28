# SPDX-License-Identifier: GPL-3.0-or-later

$dst = "$Env:LOCALAPPDATA\Microsoft\Windows\Fonts"

if ((Get-ChildItem -Filter JetBrainsMono-* $dst).Count) {
	log "Installing JetBrains Mono ... Skipped"
	exit
}

$url = Get-Content $PSScriptRoot\..\config\jb-mono-url
$tmp = ".tmp-$PID"
$zip = "$tmp/$(Split-Path $url -Leaf)"

New-Item -ItemType directory $tmp >nul

curl -L -o $zip $url
if (-not $?) {
	Remove-Item -Recurse -Force $tmp
	die "JetBrains Mono download url ``$url' is outdated"
}

Expand-Archive $zip $tmp

$pattern = "$tmp\fonts\ttf\*"
$src = Get-ChildItem -Name $pattern

if (-not (Test-Path $dst)) {
	New-Item -ItemType directory $dst >nul
}

Copy-Item $pattern $dst

$styles = 'Thin',
	  'ExtraLight',
	  'Light',
	  'Regular',
	  'Medium',
	  'SemiBold',
	  'Bold',
	  'ExtraBold',
	  'Black',
	  'Italic'
$names = 'JetBrains',
	 'Mono',
	 'NL'

foreach ($font in $src) {
	$seg = $font -split '-'
	$family = $seg[0]
	$style = $seg[1]

	$style = ($styles | Where-Object { $style -match $_ }) -join ' '
	$family = ($names | Where-Object { $family -match $_ }) -join ' '
	$key = "$family $style (TrueType)"

	New-ItemProperty -ErrorAction SilentlyContinue `
			 -PropertyType String -Value $dst\$font `
			 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' `
			 $key >nul
}

log "Installing JetBrains Mono ... OK"

Remove-Item -Recurse -Force $tmp
