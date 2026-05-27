TERMUX_PKG_HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/exfatprogs/exfatprogs/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3340a80cede17a7f94497fdc54c69c0e6ea3625e314d960551967b046eed981c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libblkid"

termux_step_pre_configure() {
	autoreconf -fiv

	CFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
