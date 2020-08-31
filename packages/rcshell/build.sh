TERMUX_PKG_HOMEPAGE=http://tobold.org/article/rc
TERMUX_PKG_DESCRIPTION="An alternative implementation of the plan 9 rc shell"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://static.tobold.org/rc/rc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=26de1c5e91a57cce96a343f1f13ebf0c1c1ff50595099fc94cb616a83157b9cb
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setpgrp_void=yes
rc_cv_sysv_sigcld=no
"
