TERMUX_PKG_HOMEPAGE=http://www.ltrace.org/
TERMUX_PKG_DESCRIPTION="Tracks runtime library calls in dynamically linked programs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://gitlab.com/cespedes/ltrace/-/archive/${TERMUX_PKG_VERSION:2}/ltrace-${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=11c85a1353fcf2b5438b19d0ccc2d376c96656ce6f11cf9537e3a92b84392c58
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libelf, libdw"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-werror
--without-libunwind
ac_cv_host=$TERMUX_ARCH-generic-linux-gnu
"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "arm" ]; then
		CFLAGS+=" -DSHT_ARM_ATTRIBUTES=0x70000000+3"
	fi

	cp "${TERMUX_PKG_BUILDER_DIR}/reallocarray.c" "${TERMUX_PKG_SRCDIR}"

	./autogen.sh
}
