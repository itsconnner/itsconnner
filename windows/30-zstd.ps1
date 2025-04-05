# SPDX-License-Identifier: GPL-3.0-or-later

if (-not (sr_is_force $args) -and (Get-Command zstd 2>NUL)) {
	log 'Installing Zstandard ... Skipped'
	exit
}

cd

if (-not (Test-Path git)) {
	New-Item -ItemType Directory git >NUL
}

cd git

if (-not (Test-Path zstd)) {
	git clone https://github.com/facebook/zstd.git
}

cd zstd

if (Test-Path build-cmake) {
	Remove-Item -Recurse
}

cmake -B build-cmake -S build/cmake -G Ninja

cd build-cmake

ninja

env-path-append $PWD\programs

log 'Installing Zstandard ... OK'
