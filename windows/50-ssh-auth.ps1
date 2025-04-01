# SPDX-License-Identifier: GPL-3.0-or-later

$key_path = "$HOME\.ssh\id_lvm_windows"
$key_pub_path = "$key_path.pub"
$config_path = "$Env:PROGRAMDATA\ssh\sshd_config"
$rec_path = "$Env:PROGRAMDATA\ssh\administrators_authorized_keys"

if (is-admin) {
	$key = Get-Content $key_pub_path
	$rec = Get-Content $rec_path 2>NUL

	if (-not ($rec | Where-Object { $_ -eq $key })) {
		Add-Content $rec_path $key
	}

	icacls $rec_path /inheritance:r /grant Administrators:F /grant SYSTEM:F

	$config = Get-Content $config_path 2>NUL
	$key_auth_str = "`nPubkeyAuthentication yes"
	$pwd_auth_str = "`nPasswordAuthentication no"

	if (-not ($config | Where-Object { $_ -eq $key_auth_str })) {
		Add-Content $config_path $key_auth_str
	}

	if (-not ($config | Where-Object { $_ -eq $pwd_auth_str })) {
		Add-Content $config_path $pwd_auth_str
	}

	restart-Service sshd
	exit
}

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Configuring sshd ... Skipped'
	exit
}

if (-not (Test-Path $key_path)) {
	die "key file $key_path not found"
}

if (-not (Test-Path $key_pub_path)) {
	ssh-keygen -y -f $key_path > $key_pub_path
}

$name = Split-Path -Leaf $PSCommandPath

run-admin $name

sr_done (script_name)
log 'Configuring sshd ... OK'
