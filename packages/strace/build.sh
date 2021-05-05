TERMUX_PKG_HOMEPAGE=https://strace.io/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor system calls and signals received"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.12
TERMUX_PKG_SRCURL=https://github.com/strace/strace/releases/download/v$TERMUX_PKG_VERSION/strace-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=29171edf9d252f89c988a4c340dfdec662f458cb8c63d85431d64bab5911e7c4
TERMUX_PKG_DEPENDS="libdw"

# Without st_cv_m32_mpers=no the build fails if gawk is installed.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
st_cv_m32_mpers=no
--enable-mpers=no
--with-libdw
"

# This is a perl script.
TERMUX_PKG_RM_AFTER_INSTALL="bin/strace-graph"

termux_step_pre_configure() {
	autoreconf # for configure.ac in 5.11fix.patch
	CPPFLAGS+=" -Dfputs_unlocked=fputs"
}
