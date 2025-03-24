# SPDX-License-Identifier: GPL-3.0-or-later

$seen = powercfg /list | Where-Object { $_ -match '\(Barroit-[\w-]+\)( \*)?$' }

$conf = load-pair $PSScriptRoot\..\conf\power-mode
$builtin = load-pair (ver-spec-name power-mode)

if ($seen -and -not (sr_is_force $args)) {
	log 'Adjusting power mode ... Skipped'
	exit
}

if (Get-CimInstance Win32_Fan) {
	$is_vm = 1
}

$mode = 'power-saver'
$default = $builtin['power_saver']
$blank = $conf['desk_blank']
$suspend = $conf['desk_suspend']

if (Get-CimInstance Win32_Battery) {
	$blank = $conf['lap_blank']
	$suspend = $conf['lap_suspend']
}

if ($is_vm) {
	$mode = 'balanced'
	$default = $builtin['balanced']
	$blank = 0
	$suspend = 0
}

if ($seen) {
	$guid = [regex]::Match($seen, '[a-fA-F0-9-]{36}').Value

	powercfg /setactive $default
	powercfg /delete $guid
}

$ret = powercfg /duplicatescheme $default
$guid = [regex]::Match($ret, '[a-fA-F0-9\-]{36}').Value

powercfg /setactive $guid
powercfg /changename $guid Barroit-$mode

powercfg /change monitor-timeout-ac $blank
powercfg /change monitor-timeout-dc $blank
powercfg /change standby-timeout-ac $suspend
powercfg /change standby-timeout-dc $suspend

log 'Adjusting power mode ... OK'
