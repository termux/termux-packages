TERMUX_PKG_HOMEPAGE=https://strace.io/
TERMUX_PKG_DESCRIPTION="Debugging utility to monitor system calls and signals received"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later, GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LGPL-2.1-or-later, bundled/linux/COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.17"
TERMUX_PKG_SRCURL=https://github.com/strace/strace/releases/download/v$TERMUX_PKG_VERSION/strace-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=0a7c7bedc7efc076f3242a0310af2ae63c292a36dd4236f079e88a93e98cb9c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libdw"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-libdw
"

termux_step_pre_configure() {
	case "$TERMUX_ARCH" in
		"x86_64") # mpers support seems to break the build on x86_64
		# This is likely an issue in `src/mpers.sh` but I can't track it down.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" st_cv_m32_mpers=no"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mpers=no"
		;;
	esac
	autoreconf # for configure.ac in configure-find-armv7-cc.patch
	CPPFLAGS+=" -Dfputs_unlocked=fputs"
}
