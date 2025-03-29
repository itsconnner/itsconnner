# SPDX-License-Identifier: GPL-3.0-or-later

if (is-admin) {
	Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
	exit
}

if (Get-Command -ErrorAction SilentlyContinue sshd) {
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
