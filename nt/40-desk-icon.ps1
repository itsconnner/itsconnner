# SPDX-License-Identifier: GPL-3.0-or-later

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Hiding desktop icons ... Skipped'
	exit
}

$def_path = ver-spec-name desk-icon
$def = load-pair $def_path

$reg = $def['reg_hide_icon']
$subreg = Get-ChildItem -Name $reg

foreach ($name in $subreg) {
	$key = "$reg\$name"
	$prop = $(Get-ItemProperty $key).PSObject.Properties
	$icon = $prop | Where-Object { $_.Name -notmatch '^PS' }

	$icon | ForEach-Object {
		Set-ItemProperty -Type DWord $key $_.Name 1
	}
}

$SHCNE_UPDATEDIR = $def['SHCNE_UPDATEDIR']
$SHCNF_PATH = $def['SHCNF_PATH']
$DESKTOP = [Environment]::GetFolderPath('Desktop')

$path = [strutil]::to_unmanaged($DESKTOP)

[syscall]::sh_change_notify($SHCNE_UPDATEDIR,
			    $SHCNF_PATH, $path, [IntPtr]::Zero)

sr_done (script_name)
log 'Hiding desktop icons ... OK'
