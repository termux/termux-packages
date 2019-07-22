TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/sed/
TERMUX_PKG_DESCRIPTION="GNU stream editor for filtering/transforming text"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=4.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	CFLAGS+=" -D__USE_FORTIFY_LEVEL=2"
}

termux_step_post_configure() {
	touch -d "next hour" $TERMUX_PKG_SRCDIR/doc/sed.1
}
