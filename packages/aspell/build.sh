TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="A free and open source spell checker designed to replace Ispell"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.60.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/aspell/aspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f9b77e515334a751b2e60daab5db23499e26c9209f5e7b7443b05235ad0226f2
TERMUX_PKG_DEPENDS="libc++"
# To use the same compiled dictionaries on every platform:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-32-bit-hash-fun"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
