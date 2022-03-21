TERMUX_PKG_HOMEPAGE=https://xapian.org
TERMUX_PKG_DESCRIPTION="Xapian search engine library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.18
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://oligarchy.co.uk/xapian/${TERMUX_PKG_VERSION}/xapian-core-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=196ddbb4ad10450100f0991a599e4ed944cbad92e4a6fe813be6dce160244b77
# Note that we cannot /proc/sys/kernel/random/uuid (permission denied on
# new android versions) so need libuuid.
TERMUX_PKG_DEPENDS="libc++, libuuid, zlib"
TERMUX_PKG_BREAKS="libxapian-dev"
TERMUX_PKG_REPLACES="libxapian-dev"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
