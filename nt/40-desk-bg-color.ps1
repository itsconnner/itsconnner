# SPDX-License-Identifier: GPL-3.0-or-later

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Changing desktop background ... Skipped'
	exit
}

$def_path = ver-spec-name desk-bg-color
$def = load-pair $def_path
$conf = load-pair $PSScriptRoot\..\conf\desk-bg-color

$SPI_SETDESKWALLPAPER = [int]$def['SPI_SETDESKWALLPAPER']
$SPIF_UPDATEINIFILE = [int]$def['SPIF_UPDATEINIFILE']
$SPIF_SENDCHANGE = [int]$def['SPIF_SENDCHANGE']

[syscall]::sys_param_info($SPI_SETDESKWALLPAPER, 0, '',
			  $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

$r = $conf['bg-r']
$g = $conf['bg-g']
$b = $conf['bg-b']

$rgb = "$r $g $b"
$hex = ($b -shl 16) -bor ($g -shl 8) -bor $r
$reg = $def['reg_background']

[syscall]::sys_colors(1, @(1), @($hex))
Set-ItemProperty $reg[0] $reg[1] $rgb

sr_done (script_name)
log 'Changing desktop background ... OK'
