# SPDX-License-Identifier: GPL-3.0-or-later

if (Test-Path ~/vcpkg) {
	log 'Deploying vcpkg ... Skipped'
	exit
}

$ws = $PWD

cd ~
git clone https://github.com/microsoft/vcpkg.git

cd vcpkg
.\bootstrap-vcpkg.bat

$old = getenv PATH
$new = "$old;$PWD"
$seen = $old -split ';' | Where-Object { $_ -eq $PWD }

if (-not $seen) {
	setenv PATH $new
}

cd $ws
log 'Deploying vcpkg ... OK'
