# SPDX-License-Identifier: GPL-3.0-or-later

if (is-admin) {
	Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

	Start-Service sshd
	Set-Service sshd -StartupType Automatic

	New-ItemProperty -PropertyType String -Force `
			 -Value (Get-Command pwsh).Source `
			 'HKLM:\SOFTWARE\OpenSSH' DefaultShell
	exit
}

if (-not (sr_is_force $args) -and (Get-Command sshd 2>NUL)) {
	log 'Installing openssh ... Skipped'
	exit
}

$name = Split-Path -Leaf $PSCommandPath

run-admin $name

note 'Start sshd once as administrator to make it function properly'
log 'Installing openssh ... OK'
