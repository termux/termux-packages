TERMUX_PKG_HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.3"
TERMUX_PKG_SRCURL="https://github.com/exfatprogs/exfatprogs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d745a0e7f97e1c36fad97148062ba4c496724e212d6075ff3129355d9054e218
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libblkid"

termux_step_pre_configure() {
	autoreconf -fiv

	CFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
