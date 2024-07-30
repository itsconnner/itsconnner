cat << EOF
Follow the default instructions illustrated on https://rclone.org/onedrive/.
The configuration profile needs to be named 'onedrive'.
EOF

waiting_user

rclone config
exit_on_error

export COMMENT='#'
export SUPERUSER=
export IOTARGET=$BASHRC
  write_on_missing "export REMOTE_FILESYS='onedrive'"
  source $BASHRC
