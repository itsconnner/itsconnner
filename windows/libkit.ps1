# SPDX-License-Identifier: GPL-3.0-or-later

. $PSScriptRoot\syscall.ps1
. $PSScriptRoot\strutil.ps1

$BOLD	= "`e[1m"
$RED	= "`e[31m"
$YELLOW	= "`e[33m"
$GREEN	= "`e[32m"
$CYAN	= "`e[36m"
$WHITE	= "`e[37m"
$RESET	= "`e[0m"

$VERSION = [System.Environment]::OSVersion.Version.Major

$SR_PATH = 'HKCU:\Software\Barroit\Barroit'

function die
{
	Write-Output "${BOLD}${RED}fatal:${RESET} $args"
	exit 128
}

function error
{
	Write-Output "${BOLD}${RED}error:${RESET} $args"
}

function warn
{
	Write-Output "${BOLD}${YELLOW}warn:${RESET} $args"
}

function note
{
	Write-Output "${BOLD}${CYAN}note:${RESET} $args"
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
	Write-Output "${BOLD}${GREEN}[$(uptime)]${RESET} $args"
}

function read-pair
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

function sr_is_force
{
	$args | Where-Object { $_ -eq 'Force=1' }
}

function script_name
{
	Split-Path -Leaf $MyInvocation.ScriptName
}

function sr_done
{
	if (-not (Test-Path $SR_PATH)) {
		New-Item -Force $SR_PATH >nul
	}

	Set-ItemProperty -Type DWord $SR_PATH $args[0] 1
}

function sr_is_done
{
	try {
		$ret = Get-ItemPropertyValue $SR_PATH $args[0]
	} catch {
		return $false
	}

	return $ret -eq 1
}

function confirm
{
	Write-Host -NoNewline "$($args[0]) [y/N] "

	do {
		$yn = $Host.UI.RawUI.ReadKey().Character
	} while (-not $yn)

	Write-Host ''
	return $yn -match '^(y|yes)$'
}

function likely-vm
{
	return -not (Get-CimInstance Win32_Fan)
}

function getenv2
{
	[Environment]::GetEnvironmentVariable($args[0], $args[1])
}

function getenv
{
	getenv2 $args[0] 'User'
}

function setenv
{
	[Environment]::SetEnvironmentVariable($args[0], $args[1], 'User')
}

function sync-env-path
{
	$Env:PATH = "$(getenv2 PATH 'User');$(getenv2 PATH 'Machine')"
}

function read-line
{
	Get-Content $args[0] | Where-Object {
		$_ -and $_ -notmatch '^#'
	}
}

function env-path-append
{
	$name = $args[0]
	$old = getenv PATH
	$new = "$old;$name"
	$seen = $old -split ';' | Where-Object { $_ -eq $name }

	if (-not $seen) {
		setenv PATH $new
	}
}

function is-admin
{
	$user = [Security.Principal.WindowsIdentity]::GetCurrent()
	$user = [Security.Principal.WindowsPrincipal]$user
	$admin = [Security.Principal.WindowsBuiltInRole]::Administrator

	return $user.IsInRole($admin)
}
