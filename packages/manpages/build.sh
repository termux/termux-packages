TERMUX_PKG_HOMEPAGE=https://www.kernel.org/doc/man-pages/
TERMUX_PKG_DESCRIPTION="Man pages for linux kernel and C library interfaces"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSES/Linux-man-pages-copyleft.txt, _man-pages-posix/POSIX-COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(6.01
		    2017)
TERMUX_PKG_SHA256=(8be5177b2788c480a984517947d602ffaa64edeaed83edf4bd04f35163cb5c0b
		   ce67bb25b5048b20dad772e405a83f4bc70faf051afa289361c81f9660318bc3)
TERMUX_PKG_SRCURL=(https://www.kernel.org/pub/linux/docs/man-pages/man-pages-${TERMUX_PKG_VERSION}.tar.xz
		   https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-${TERMUX_PKG_VERSION[1]}-a.tar.xz)
TERMUX_PKG_DEPENDS="man"
TERMUX_PKG_CONFLICTS="linux-man-pages"
TERMUX_PKG_REPLACES="linux-man-pages"
TERMUX_PKG_PROVIDES="linux-man-pages"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
# Problems with changing permissions of non-built files
TERMUX_MAKE_PROCESSSES=1

# Do not remove an entire section; intro should always be included.
# Bionic libc does not provide <aio.h>, <monetary.h> or pthread_cancel.
# man.7 and mdoc.7 is included with mandoc:
# getconf man page included with the getconf package:
# iconv-related manpages included with libiconv package:
TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man0p/aio.h.0p
share/man/man0p/monetary.h.0p
share/man/man1p/getconf.1p
share/man/man3/aio_*
share/man/man3/aiocb.3
share/man/man3/iconv.3
share/man/man3/iconv_close.3
share/man/man3/iconv_open.3
share/man/man3/pthread_*cancel*.3
share/man/man3p/aio_*
share/man/man3p/pthread_*cancel*.3p
share/man/man7/aio.7
share/man/man7/man.7
share/man/man7/mdoc.7
"

termux_step_post_get_source() {
	mv man-pages-posix-${TERMUX_PKG_VERSION[1]} _man-pages-posix
}

termux_step_make() {
	:
}

termux_step_post_make_install() {
	# Bundle POSIX man pages in the same package:
	make -C _man-pages-posix install
}

termux_step_post_massage() {
	local s
	for s in 1 8; do
		pushd share/man/man${s}
		find . -mindepth 1 -maxdepth 1 ! -name "intro.${s}.gz" \
				-exec rm -rf "{}" \;
		popd
	done
}
