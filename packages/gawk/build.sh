TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gawk/
TERMUX_PKG_DESCRIPTION="Programming language designed for text processing"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gawk/gawk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cf5fea4ac5665fd5171af4716baab2effc76306a9572988d5ba1078f196382bd
TERMUX_PKG_DEPENDS="libandroid-support, libgmp, libmpfr, readline"
TERMUX_PKG_BREAKS="gawk-dev"
TERMUX_PKG_REPLACES="gawk-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Remove old symlink to force a fresh timestamp:
	rm -f $TERMUX_PREFIX/bin/awk

	# http://cross-lfs.org/view/CLFS-2.1.0/ppc64-64/temp-system/gawk.html
	cp -v extension/Makefile.in{,.orig}
	sed -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in.orig > extension/Makefile.in
}
