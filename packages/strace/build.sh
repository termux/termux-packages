TERMUX_PKG_HOMEPAGE=https://strace.io/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor system calls and signals received"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING, LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1"
TERMUX_PKG_SRCURL=https://github.com/strace/strace/releases/download/v$TERMUX_PKG_VERSION/strace-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=2579e9cec37dbb786f6ea0bebd15f40dd561ef2bde2a2a2ecdce5963b01859fd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libdw"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-libdw
"

# This is a perl script.
TERMUX_PKG_RM_AFTER_INSTALL="bin/strace-graph"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "arm" ] || [ "$TERMUX_ARCH" = "i686" ] || [ "$TERMUX_ARCH" = "x86_64" ]; then
		# Without st_cv_m32_mpers=no the build fails if gawk is installed.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" st_cv_m32_mpers=no"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mpers=no"
	fi
	autoreconf # for configure.ac in configure-find-armv7-cc.patch
	CPPFLAGS+=" -Dfputs_unlocked=fputs"
}
