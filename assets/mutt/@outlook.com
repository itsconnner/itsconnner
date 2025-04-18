# SPDX-License-Identifier: GPL-3.0-or-later

source ~/.mutt/xoauth2

set smtp_url = "smtp://$imap_user@smtp-mail.outlook.com:587/"

set folder    = 'imaps://outlook.office365.com/'
set spoolfile = +Inbox
set postponed = +Drafts
set trash     = +Deleted

# Prevent duplication
unset record

# Deletes go to 'Deleted Items', but also copy to 'Recoverable Items'. So you
# can't truly delete mail through Mutt.
set delete
