# SPDX-License-Identifier: GPL-3.0-or-later

Add-Type @'
using System;
using System.Runtime.InteropServices;

public class syscall
{

[DllImport("user32.dll")]
private static extern bool SetSysColors(int n, int[] el, int[] colors);

[DllImport("user32.dll")]
private static extern int SystemParametersInfo(int act, int p1,
					       string p2, int flags);

[DllImport("shell32.dll")]
private static extern void SHChangeNotify(int id, uint flags,
					  IntPtr i1, IntPtr i2);

[DllImport("user32.dll")]
public static extern bool SendNotifyMessage(IntPtr wnd, uint msg,
					    UIntPtr wp, IntPtr lp);

public static void sys_colors(int n, int[] el, int[] colors)
{
	SetSysColors(n, el, colors);
}

public static void sys_param_info(int act, int p1, string p2, int flags)
{
	SystemParametersInfo(act, p1, p2, flags);
}

public static void sh_change_notify(int id, uint flags, IntPtr i1, IntPtr i2)
{
	SHChangeNotify(id, flags, i1, i2);
}

public static void send_notify_message(IntPtr wnd, uint msg,
				       UIntPtr wp, IntPtr lp)
{
	SendNotifyMessage(wnd, msg, wp, lp);
}

} /* class syscall */
'@
