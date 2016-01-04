TERMUX_PKG_HOMEPAGE=https://sourceware.org/libffi/
TERMUX_PKG_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/libffi/libffi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_RM_AFTER_INSTALL="lib/libffi-${TERMUX_PKG_VERSION}/include"

termux_step_post_make_install () {
	if [ $TERMUX_ARCH_BITS = "64" ]; then
		# Avoid libffi being placed in lib64 for 64-bit builds:
		mv $TERMUX_PREFIX/lib64/libffi* $TERMUX_PREFIX/lib/
	fi
}
