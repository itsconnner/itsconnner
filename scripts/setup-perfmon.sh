# SPDX-License-Identifier: GPL-3.0-only

COMMENT='#'

SUPERUSER=1
IOTARGET='/etc/sysctl.d/br-perfmon.conf'
  write_on_missing 'kernel.perf_event_paranoid = -1'
  sudo service procps reload
