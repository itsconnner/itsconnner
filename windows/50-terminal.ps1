# SPDX-License-Identifier: GPL-3.0-or-later

$wt_path = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"
$conf_path = "$wt_path\LocalState\settings.json"
$udef_path = "$PSScriptRoot\..\config\windows-terminal"

$conf = Get-Content $conf_path | ConvertFrom-Json -AsHashtable
$udef = Get-Content $udef_path
$prof = @{}

$profiles = $conf['profiles']['list']
$barroit = $profiles | Where-Object { $_.name -eq 'Barroit' }
$pwsh = $profiles | Where-Object { $_.name -eq 'Barroit' }

if ($barroit) {
	log "Importing Windows Terminal settings ... Skipped"
	exit
}

foreach ($profile in $profiles) {
	$prof[$profile.name] = $profile
}

foreach ($def in $udef) {
	if (-not $def) {
		continue
	}

	$seg = $def -split '\t' | Where-Object { $_ }
	$pth = $conf
	$val = $seg[-1]
	$last_key = ''

	for ($i = 0; $i -lt $seg.Length - 1; $i++) {
		$key = $seg[$i]

		$key_seg = $key -split '_'
		$words = @()

		for ($j = 1; $j -lt $key_seg.Length; $j++) {
			$word = $key_seg[$j]

			$words += $word.Substring(0,1).ToUpper() +
				  $word.Substring(1);
		}

		$key = $key_seg[0] + ($words -join '')

		if ($key -match '^\$P:') {
			$pth = $prof[$key.Substring(3)]
			continue
		}

		if ($i -ne $seg.Length - 2) {
			if (-not $pth.ContainsKey($key)) {
				$pth[$key] = @{}
			}

			$pth = $pth[$key]
		} else {
			$last_key = $key
		}
	}

	if ($val.Length -gt 3 -and $val[0] -eq '$' -and $val[2] -eq ':') {
		switch ($val[1]) {
		'N' { $val = [int]$val.Substring(3) }
		'B' { $val = $val[3] -eq '0' ? $false : $true }
		'U' { $val = $prof[$val.Substring(3)]['guid'] }
		}
	}

	$pth[$last_key] = $val
}

$conf['profiles']['list'] += @{
	name = 'Barroit'
	hidden = $true
}

$conf | ConvertTo-Json -Depth 39 | Set-Content $conf_path

log "Importing Windows Terminal settings ... OK"
