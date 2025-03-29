# SPDX-License-Identifier: GPL-3.0-or-later

cat << EOF
The following options need to be set
	keyboard model			    to	General 105-key PC
	country of origin for the keyboard  to	Japanese
EOF

waiting_user

sudo dpkg-reconfigure keyboard-configuration
exit_on_error

COMMENT='#'
SUPERUSER=
IOTARGET=$PROFILE
  write_on_missing 'xmodmap "$HOME/.Xmodmap"'
  xmodmap "$HOME/.Xmodmap"
