TERMUX_PKG_HOMEPAGE=https://github.com/tuxera/ntfs-3g
TERMUX_PKG_DESCRIPTION="NTFS-3G Safe Read/Write NTFS Driver"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.10.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tuxera/ntfs-3g/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8bd7749ea9d8534c9f0664d48b576e90b96d45ec8803c9427f6ffaa2f0dde299
TERMUX_PKG_BUILD_DEPENDS="libfuse2, libgcrypt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-fuse=external --exec-prefix=$TERMUX_PREFIX --prefix=/"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include/fuse"
	NOCONFIGURE=1 autoreconf -vfi -I"$TERMUX_PREFIX/share/aclocal/"
}

termux_step_make_install() {
	make install DESTDIR="$TERMUX_PREFIX" man8dir="/share/man/man8" rootlibdir="/lib/" libdir="/lib/" rootbindir="/bin/" bindir="/bin/" sbindir="/bin"
}
