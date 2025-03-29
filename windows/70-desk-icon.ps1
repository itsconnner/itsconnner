# SPDX-License-Identifier: GPL-3.0-or-later

$SHCNE_UPDATEDIR = 0x00001000
$SHCNF_PATH = 0x0005

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Hiding desktop icons ... Skipped'
	exit
}

$prefix = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
$items = Get-ChildItem -Name $prefix

foreach ($name in $items) {
	$key = "$prefix\$name"
	$prop = $(Get-ItemProperty $key).PSObject.Properties
	$icon = $prop | Where-Object { $_.Name -notmatch '^PS' }

	$icon | ForEach-Object {
		Set-ItemProperty -Type DWord $key $_.Name 1
	}
}

$DESKTOP = [Environment]::GetFolderPath('Desktop')

[syscall]::sh_change_notify($SHCNE_UPDATEDIR, $SHCNF_PATH,
			    [strutil]::to_unmanaged($DESKTOP), [IntPtr]::Zero)

sr_done (script_name)
log 'Hiding desktop icons ... OK'
