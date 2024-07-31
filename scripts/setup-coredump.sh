# SPDX-License-Identifier: GPL-3.0-only

export COMMENT='#'

export SUPERUSER=
export IOTARGET=$BASHRC
  write_on_missing 'ulimit -c unlimited'
  source $BASHRC

if systemctl status apport.service >/dev/null 2>&1; then
	sudo systemctl stop apport.service
	sudo systemctl disable apport.service
fi

export SUPERUSER=1
export IOTARGET='/etc/sysctl.d/br-coredump.conf'
  write_on_missing 'kernel.core_uses_pid = 0'
  write_on_missing 'kernel.core_pattern = core.%e'
  sudo service procps reload
