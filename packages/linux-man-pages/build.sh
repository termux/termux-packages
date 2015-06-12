TERMUX_PKG_HOMEPAGE=https://www.kernel.org/doc/man-pages/
TERMUX_PKG_DESCRIPTION="Man pages for linux kernel and C library interfaces"
TERMUX_PKG_VERSION=4.00
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/docs/man-pages/man-pages-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX"
# man.7 and mdoc.7 is included with mandoc:
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1 share/man/man8 share/man/man7/man.7 share/man/man7/mdoc.7"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make () {
        # Fresh timestamps on files:
        make uninstall
}
