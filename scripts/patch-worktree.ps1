# SPDX-License-Identifier: GPL-3.0-or-later

$origin = $PWD

if (-not $args.Count) {
	cd .
} else {
	cd $args[0]
}

git add .

git commit -smTMP
git format-patch HEAD~1

git reset HEAD^
git restore --staged .

Invoke-Item .

cd $origin
