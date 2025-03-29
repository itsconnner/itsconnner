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

$letter = $PSScriptRoot[0]
$drive = Get-PSDrive $letter
$name = Split-Path -Leaf $PSCommandPath

if ($drive.DisplayRoot) {
	$root = $drive.DisplayRoot.TrimEnd([char]0)
	$cmd += "New-PSDrive $letter FileSystem '$root'; "
}

$cmd += "& $PSScriptRoot\setup.ps1 $name"

Start-Process -Verb RunAs -Wait pwsh '-Command', $cmd

log 'Installing openssh ... OK'
