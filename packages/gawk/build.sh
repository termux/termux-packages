TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gawk/
TERMUX_PKG_DESCRIPTION="Programming language designed for text processing"
TERMUX_PKG_DEPENDS="libandroid-support, libmpfr, libgmp, readline"
TERMUX_PKG_VERSION=4.2.1
TERMUX_PKG_SHA256=d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gawk/gawk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"

termux_step_pre_configure () {
	# Remove old symlink to force a fresh timestamp:
	rm -f $TERMUX_PREFIX/bin/awk

	# http://cross-lfs.org/view/CLFS-2.1.0/ppc64-64/temp-system/gawk.html
	cp -v extension/Makefile.in{,.orig}
	sed -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in.orig > extension/Makefile.in
}
