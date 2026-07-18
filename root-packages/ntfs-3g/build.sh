TERMUX_PKG_HOMEPAGE=https://github.com/tuxera/ntfs-3g
TERMUX_PKG_DESCRIPTION="NTFS-3G Safe Read/Write NTFS Driver"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.7.7"
TERMUX_PKG_SRCURL=https://github.com/tuxera/ntfs-3g/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7742bfe3399a7b2f677fea8aa193dc21d38112d77ae8beb0fb66aaf550f72c1d
TERMUX_PKG_DEPENDS="libfuse2"
TERMUX_PKG_BUILD_DEPENDS="libgcrypt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-fuse=external --exec-prefix=$TERMUX_PREFIX --prefix=/"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include/fuse"
	autoreconf -vfi
}

termux_step_make_install() {
	make install \
		DESTDIR="$TERMUX_PREFIX" \
		man8dir="/share/man/man8" \
		rootlibdir="/lib/" \
		libdir="/lib/" \
		rootbindir="/bin/" \
		bindir="/bin/" \
		sbindir="/bin" \
		includedir="/include"
}
