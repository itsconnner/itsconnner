# SPDX-License-Identifier: GPL-3.0-or-later

function is_activated
{
	$product = Get-CimInstance -Query "SELECT LicenseStatus `
					   FROM SoftwareLicensingProduct `
					   WHERE PartialProductKey IS NOT NULL"
	$state = $product.LicenseStatus

	return $state -eq 1
}

if (is_activated) {
	log "Activating Windows ... Skipped"
	exit
}

$domain = Get-Content $PSScriptRoot\..\conf\mas-domain

Resolve-DnsName -ErrorAction SilentlyContinue $domain >nul
if (-not $?) {
	die "Microsoft Activation Scripts domain ``$domain' is outdated"
}

Invoke-RestMethod https://$domain | Invoke-Expression
if (-not (is_activated)) {
	die 'Windows activation failed'
}

log "Activating Windows ... OK"
