TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/sed/
TERMUX_PKG_DESCRIPTION="GNU stream text editor"
TERMUX_PKG_VERSION=4.4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cbd6ebc5aaf080ed60d0162d7f6aeae58211a1ee9ba9bb25623daa6cd942683b
TERMUX_PKG_BUILD_IN_SRC=yes
# XXX: A build with clang causes undefined references to __muloti4:
TERMUX_PKG_CLANG=no

termux_step_post_configure () {
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_SRCDIR/doc/sed.1
}
