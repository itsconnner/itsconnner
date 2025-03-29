# SPDX-License-Identifier: GPL-3.0-or-later

COMMENT='#'

SUPERUSER=
IOTARGET=$BASHRC
  write_on_missing 'ulimit -c unlimited'

if systemctl status apport.service >/dev/null 2>&1; then
	sudo systemctl stop apport.service
	sudo systemctl disable apport.service
fi

SUPERUSER=1
IOTARGET='/etc/sysctl.d/br-coredump.conf'
  write_on_missing 'kernel.core_uses_pid = 0'
  write_on_missing 'kernel.core_pattern = core.%e'
  sudo service procps reload
