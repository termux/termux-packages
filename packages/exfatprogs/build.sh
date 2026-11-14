TERMUX_PKG_HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.4"
TERMUX_PKG_SRCURL="https://github.com/exfatprogs/exfatprogs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6ffb35a2a2b578019bf33da71836587857c990fb9e998d89eb333757ba779565
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libblkid"

termux_step_pre_configure() {
	autoreconf -fiv

	CFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
