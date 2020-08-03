TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gawk/
TERMUX_PKG_DESCRIPTION="Programming language designed for text processing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gawk/gawk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3c1fce1446b4cbee1cd273bd7ec64bc87d89f61537471cd3e05e33a965a250e9
TERMUX_PKG_DEPENDS="libandroid-support, libgmp, libmpfr, readline"
TERMUX_PKG_BREAKS="gawk-dev"
TERMUX_PKG_REPLACES="gawk-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pma
"

termux_step_pre_configure() {
	sed -i -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin
	ln -sf gawk awk
}
