TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL=https://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6cea3f49952a47224439a40bdb3608f928d121ad8721b9921cc42802d548ecf8
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
