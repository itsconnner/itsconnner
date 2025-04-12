# SPDX-License-Identifier: GPL-3.0-or-later

$fsrule = [System.Security.AccessControl.FileSystemAccessRule]

if (-not (sr_is_force $args) -and (sr_is_done (script_name))) {
	log 'Copying private keys ... Skipped'
	exit
}

if (-not (Test-Path S:\)) {
	die "GPG file storage didn't mount to S:"
}

$rule = New-Object $fsrule($env:USERNAME, 'Read', 'Allow')

:dumbass_continue foreach ($sec in (Get-ChildItem -Filter *.gpg -Name S:\)) {
	log "Importing $sec ..."

	switch -Regex ($sec) {
	'^pg' {
		gpg --import S:\$sec
		if (-not $?) {
			error "Importing $sec ... Failed"
			continue dumbass_continue
		}
	}
	'^id' {
		$name = (Get-Item S:\$sec).BaseName
		$dst = "$HOME\.ssh\$name"

		Remove-Item -ErrorAction SilentlyContinue $dst

		gpg -o $dst -d S:\$sec
		if (-not $?) {
			error "Importing $name ... Failed"
			continue dumbass_continue
		}

		$acl = Get-Acl $dst

		$acl.SetAccessRuleProtection($true, $false)

		$acl.Access | ForEach-Object {
			$acl.RemoveAccessRule($_)
		}

		$acl.AddAccessRule($rule)
		Set-Acl $dst $acl
	}
	default {
		continue dumbass_continue
	}
	}

	log "Importing $sec ... DONE"
}

sr_done (script_name)
log 'Copying private keys ... OK'
