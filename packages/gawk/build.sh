TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/gawk/
TERMUX_PKG_DESCRIPTION="Interpreted programming language designed for text processing and typically used as a data extraction and reporting tool"
TERMUX_PKG_DEPENDS="libandroid-support, libmpfr, libgmp, readline"
TERMUX_PKG_VERSION=4.1.4
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/gawk/gawk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"

termux_step_pre_configure () {
	# Remove old symlink to force a fresh timestamp:
	rm -f $TERMUX_PREFIX/bin/awk

	# http://cross-lfs.org/view/CLFS-2.1.0/ppc64-64/temp-system/gawk.html
        cd $TERMUX_PKG_SRCDIR
	cp -v extension/Makefile.in{,.orig}
	sed -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in.orig > extension/Makefile.in
}
