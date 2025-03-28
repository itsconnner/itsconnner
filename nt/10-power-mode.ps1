# SPDX-License-Identifier: GPL-3.0-or-later

$seen = powercfg /list | Where-Object { $_ -match '\(Barroit-[\w-]+\)( \*)?$' }

$conf = load-pair $PSScriptRoot\..\conf\power-mode

if ($seen -and -not (sr_is_force $args)) {
	log 'Adjusting power mode ... Skipped'
	exit
}

if (likely-vm) {
	$is_vm = 1
}

$mode = 'power-saver'
$default = 'a1841308-3541-4fab-bc81-f71556f20b4a'
$blank = $conf['desk_blank']
$suspend = $conf['desk_suspend']

if (Get-CimInstance Win32_Battery) {
	$blank = $conf['lap_blank']
	$suspend = $conf['lap_suspend']
}

if ($is_vm) {
	$mode = 'balanced'
	$default = '381b4222-f694-41f0-9685-ff5bb260df2e'
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
