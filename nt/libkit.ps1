# SPDX-License-Identifier: GPL-3.0-or-later

$RED	= "`e[0;31m"
$YELLOW	= "`e[0;33m"
$GREEN	= "`e[0;32m"
$CYAN	= "`e[0;36m"
$WHITE	= "`e[0;37m"
$RESET	= "`e[0m"

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
