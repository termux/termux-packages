TERMUX_PKG_HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.8"
TERMUX_PKG_SRCURL="https://github.com/exfatprogs/exfatprogs/releases/download/${TERMUX_PKG_VERSION}/exfatprogs-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7be42b224faa1caed42ccf90ce0184551d022fa1d2175f61c6c29e8babb05cca
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
