# SPDX-License-Identifier: GPL-3.0-or-later

set imap_user = 'barroit39@gmail.com'
set from      = $imap_user

source ~/.mutt/@gmail.com
