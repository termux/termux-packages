TERMUX_PKG_HOMEPAGE=https://strace.io/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor system calls and signals received"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=5.3
TERMUX_PKG_SRCURL=https://github.com/strace/strace/releases/download/v$TERMUX_PKG_VERSION/strace-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6c131198749656401fe3efd6b4b16a07ea867e8f530867ceae8930bbc937a047
TERMUX_PKG_RM_AFTER_INSTALL=bin/strace-graph # This is a perl script
# Without st_cv_m32_mpers=no the build fails if gawk is installed.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
st_cv_m32_mpers=no
--enable-mpers=no
--without-libdw
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Dfputs_unlocked=fputs"
}
