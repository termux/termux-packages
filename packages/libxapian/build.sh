TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.21
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=80f86034d2fb55900795481dfae681bfaa10efbe818abad3622cdc0c55e06f88
# Note that we cannot /proc/sys/kernel/random/uuid (permission denied on
# new android versions) so need libuuid (>> 2.38.1).
TERMUX_PKG_DEPENDS="libc++, libuuid (>> 2.38.1), zlib"
TERMUX_PKG_BREAKS="libxapian-dev"
TERMUX_PKG_REPLACES="libxapian-dev"
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/xapian-core/
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
