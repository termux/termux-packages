TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/sed/
TERMUX_PKG_DESCRIPTION="GNU stream text editor"
TERMUX_PKG_VERSION=4.3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=47c20d8841ce9e7b6ef8037768aac44bc2937fff1c265b291c824004d56bd0aa
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure () {
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_SRCDIR/doc/sed.1
}
