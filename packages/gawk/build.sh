TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gawk/
TERMUX_PKG_DESCRIPTION="Programming language designed for text processing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gawk/gawk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d87629386e894bbea11a5e00515fc909dc9b7249529dad9e6a3a2c77085f7ea2
TERMUX_PKG_DEPENDS="libandroid-support, libgmp, libmpfr, readline"
TERMUX_PKG_BREAKS="gawk-dev"
TERMUX_PKG_REPLACES="gawk-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	sed -i -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin
	ln -sf gawk awk
}
