TMPDIR='/tmp/oneshot-exec'

export COMMENT='#'

export SUPERUSER=1
export IOTARGET='/etc/tmpfiles.d/br-oneshot-exec.conf'
  write_on_missing "d $TMPDIR 0700 $USER $USER -"
  write_on_missing "e! $TMPDIR - - - 0"
  systemd-tmpfiles --create "$IOTARGET"

export SUPERUSER=
export IOTARGET=$BASHRC
  write_on_missing "export ONESHOT_LIST='$TMPDIR'"
  source $BASHRC
