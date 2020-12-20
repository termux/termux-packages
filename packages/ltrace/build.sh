TERMUX_PKG_HOMEPAGE=http://www.ltrace.org/
TERMUX_PKG_DESCRIPTION="Tracks runtime library calls in dynamically linked programs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.7.3
TERMUX_PKG_SRCURL=https://github.com/dkogan/ltrace/archive/82c66409c7a93ca6ad2e4563ef030dfb7e6df4d4.tar.gz
TERMUX_PKG_SHA256=4aecf69e4a33331aed1e50ce4907e73a98cbccc4835febc3473863474304d547
TERMUX_PKG_DEPENDS="libc++, libelf"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-werror
--without-libunwind
ac_cv_host=$TERMUX_ARCH-generic-linux-gnu
"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "arm" ]; then
		CFLAGS+=" -DSHT_ARM_ATTRIBUTES=0x70000000+3"
	fi

	autoreconf -i ../src
}
