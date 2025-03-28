# SPDX-License-Identifier: GPL-3.0-or-later

$SPI_SETDESKWALLPAPER = 0x14
$SPIF_UPDATEINIFILE = 0x1
$SPIF_SENDCHANGE = 0x2

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Changing desktop background ... Skipped'
	exit
}

[syscall]::sys_param_info($SPI_SETDESKWALLPAPER, 0, '',
			  $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

$conf = read-pair $PSScriptRoot\..\conf\desk-bg-color

$r = $conf['bg-r']
$g = $conf['bg-g']
$b = $conf['bg-b']

[syscall]::sys_colors(1, @(1), @(($b -shl 16) -bor ($g -shl 8) -bor $r))

Set-ItemProperty 'HKCU:\Control Panel\Colors' Background "$r $g $b"

sr_done (script_name)
log 'Changing desktop background ... OK'
