TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL=https://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8e1259586d342e3d12b5e1f772e9185a10f2ba16e541566b5c3c239f71b8aacc
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
