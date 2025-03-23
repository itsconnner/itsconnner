# SPDX-License-Identifier: GPL-3.0-or-later

Add-Type @'
using System;
using System.Runtime.InteropServices;

public class strutil
{

public static IntPtr to_unmanaged(string str) {
		return Marshal.StringToHGlobalUni(str);
}

} /* class strutil */
'@
