#!/bin/zsh
# SPDX-License-Identifier: GPL-3.0-or-later

if ! exec_is_foce && setup_is_done; then
	log 'Configuring Wasabi cloud storage ... Skipped'
	exit
fi

secret=/Volumes/secret

if [[ ! -d $secret ]]; then
	die "GPG file storage didn't mount to \`$secret'"
fi

mkdir -p ~/.config/rclone
cd ~/.config/rclone

if ! confirm 'import rclone.conf?'; then
	exit 128
fi

gpg --yes -o rclone.conf -d $secret/rclone.conf.gpg

if [[ $? -ne 0 ]]; then
	die "Importing rclone.conf ... Failed"
fi

mkdir -p ~/Library/LaunchAgents
cd ~/Library/LaunchAgents

cat <<EOF > cc.barroit.wasabi.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
                       "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>cc.barroit.wasabi</string>

    <key>ProgramArguments</key>
    <array>
      <string>$SCRIPT_ROOT/wasabi.launchd.sh</string>
    </array>

    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

if ! launchctl list | grep -q cc.barroit.wasabi; then
	launchctl bootstrap gui/$(id -u) cc.barroit.wasabi.plist
fi

setup_done
log 'Configuring Wasabi cloud storage ... OK'
