# SPDX-License-Identifier: GPL-3.0-or-later

TMPDIR='/tmp/oneshot-exec'

COMMENT='#'

SUPERUSER=1
IOTARGET='/etc/tmpfiles.d/br-oneshot-exec.conf'
  write_on_missing "d $TMPDIR 0700 $USER $USER -"
  write_on_missing "e! $TMPDIR - - - 0"
  systemd-tmpfiles --create "$IOTARGET"

SUPERUSER=
IOTARGET=$BASHRC
  write_on_missing "export ONESHOT_LIST='$TMPDIR'"
  source $BASHRC
