TERMUX_PKG_HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.9"
TERMUX_PKG_SRCURL="https://github.com/exfatprogs/exfatprogs/releases/download/${TERMUX_PKG_VERSION}/exfatprogs-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6233a422d7dae9f3b1f279e6a8dd35f3976d085358c587d5308be274f04725e0
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
