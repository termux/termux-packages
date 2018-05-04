TERMUX_PKG_HOMEPAGE=https://github.com/tux-mind/libbthread
TERMUX_PKG_MAINTAINER="tux-mind"
TERMUX_PKG_DESCRIPTION="libpthread add-on."
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SRCURL=https://github.com/tux-mind/libbthread/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d38d8e684d6fba376ea1c774da411495f369b369fd588dc1d260bd58ff4eb818
TERMUX_PKG_FOLDERNAME="libbthread-${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="ndk-sysroot"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	libtoolize --force
	aclocal
	autoconf
	autoheader
	automake -a
}
