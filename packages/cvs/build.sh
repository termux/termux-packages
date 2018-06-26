TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/cvs/
TERMUX_PKG_DESCRIPTION="Concurrent Versions System"
TERMUX_PKG_VERSION=1.12.13
TERMUX_PKG_SHA256=27f3bc1be1f538a8390faab1d452db3ea90f55065e3dc0efe095457243a409b3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/old/cvs-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
cvs_cv_func_printf_ptr=yes
ac_cv_header_syslog_h=no
--disable-server
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/cvsbug share/man/man8/cvsbug.8"
