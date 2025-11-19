TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.29"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c55c9bc8613ad3ec2c218eafca088c218ab7cddcba7ef08f3af0e542f4e521bc
TERMUX_PKG_AUTO_UPDATE=true
# Note that we cannot /proc/sys/kernel/random/uuid (permission denied on
# new android versions) so need libuuid.
TERMUX_PKG_DEPENDS="libc++, libuuid, zlib"
TERMUX_PKG_BREAKS="libxapian-dev"
TERMUX_PKG_REPLACES="libxapian-dev"
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/xapian-core/
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
