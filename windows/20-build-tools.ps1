# SPDX-License-Identifier: GPL-3.0-or-later

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Installing BuildTools ... Skipped'
	exit
}

$id = 'Microsoft.VisualStudio.2022.BuildTools'

if ($Env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
	$vctool = 'Microsoft.VisualStudio.Component.VC.Tools.ARM64'
} else {
	$vctool = 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64'
}

$sdk = 'Microsoft.VisualStudio.Component.Windows11SDK.26100'

winget install --id=$id --custom="--add=$vctool --add=$sdk"

env-path-append "${Env:PROGRAMFILES(x86)}\Microsoft Visual Studio\Installer"

sr_done (script_name)
log 'Installing BuildTools ... OK'
