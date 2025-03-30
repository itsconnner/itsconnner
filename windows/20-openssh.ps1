# SPDX-License-Identifier: GPL-3.0-or-later

if (is-admin) {
	Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

	Start-Service sshd
	Set-Service sshd -StartupType Automatic

	note 'Start sshd once as administrator to make it function properly'
	exit
}

if (-not (sr_is_force $args) -and (Get-Command sshd 2>NUL)) {
	log 'Installing openssh ... Skipped'
	exit
}

$name = Split-Path -Leaf $PSCommandPath

run-admin $name

log 'Installing openssh ... OK'
