# SPDX-License-Identifier: GPL-3.0-or-later

. $PSScriptRoot\syscall.ps1

$RED	= "`e[0;31m"
$YELLOW	= "`e[0;33m"
$GREEN	= "`e[0;32m"
$CYAN	= "`e[0;36m"
$WHITE	= "`e[0;37m"
$RESET	= "`e[0m"

$VERSION = [System.Environment]::OSVersion.Version.Major

function die
{
	Write-Output "${RED}fatal:${RESET} $args"
	exit 128
}

function error
{
	Write-Output "${RED}error:${RESET} $args"
}

function warn
{
	Write-Output "${YELLOW}warn:${RESET} $args"
}

function note
{
	Write-Output "${CYAN}note:${RESET} $args"
}

function uptime
{
	$prev = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
	$next = Get-Date
	$uptime = $next - $prev

	return '{0:F2}' -f $uptime.TotalSeconds
}

function log
{
	Write-Output "${GREEN}[$(uptime)]${RESET} $args"
}

function ver-spec-name
{
	$name = "$PSScriptRoot\..\windows-$($VERSION)\$($args[0])"

	if (-not (Test-Path $name)) {
		die "version-specified file ``$name' doesn't exist"
	}

	return $name
}

function load-pair
{
	$ret = @{}
	$sep = '\t'

	if ($args.Length -gt 1) {
		$sep = $args[1]
	}

	Get-Content $args[0] | ForEach-Object {
		if (-not $_ -or $_ -match '^#') {
			return
		}

		$pair = $_ -split $sep | Where-Object { $_ }

		if ($pair.Length -eq 2) {
			$ret[$pair[0]] = $pair[1]
		} else {
			$ret[$pair[0]] = $pair[1..($pair.Length - 1)]
		}
	}

	return $ret
}
