TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/sed/
TERMUX_PKG_DESCRIPTION="GNU stream editor for filtering/transforming text"
TERMUX_PKG_VERSION=4.5
TERMUX_PKG_SHA256=7aad73c8839c2bdadca9476f884d2953cdace9567ecd0d90f9959f229d146b40
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure () {
	touch -d "next hour" $TERMUX_PKG_SRCDIR/doc/sed.1
}
