# SPDX-License-Identifier: GPL-3.0-or-later

$fsrule = [System.Security.AccessControl.FileSystemAccessRule]

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Copying private keys ... Skipped'
	exit
}

if (-not (Test-Path L:\)) {
	die "LOCKER did not mount to L:"
}

$tmpd = "L:\.tmp-$PID"
$rule = New-Object $fsrule($env:USERNAME, 'Read', 'Allow')

New-Item -ItemType Directory $tmpd >NUL

foreach ($sec in (Get-ChildItem -Filter *.gpg -Name L:\)) {
	log "Importing $sec ..."
	switch -Regex ($sec) {
	'^pg' {
		gpg --import L:\$sec
		if (-not $?) {
			warn "Importing $sec ... Failed"
			continue
		}
	}
	'^id' {
		gpg -o $tmpd\$sec -d L:\$sec
		if (-not $?) {
			warn "Importing $sec ... Failed"
			continue
		}

		$name = (Get-Item $tmpd\$sec).BaseName
		$dst = "$HOME\.ssh\$name"

		Remove-Item -ErrorAction SilentlyContinue $dst
		Move-Item $tmpd\$sec $dst

		$acl = Get-Acl $dst

		$acl.SetAccessRuleProtection($true, $false)

		$acl.Access | ForEach-Object {
			$acl.RemoveAccessRule($_)
		}

		$acl.AddAccessRule($rule)
		Set-Acl $dst $acl
	}
	}

	log "Importing $sec ... DONE"
}

Remove-Item -Force $tmpd

sr_done (script_name)
log 'Copying private keys ... OK'
