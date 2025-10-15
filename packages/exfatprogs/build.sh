TERMUX_PKG_HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
TERMUX_PKG_DESCRIPTION="exFAT filesystem userspace utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL="https://github.com/exfatprogs/exfatprogs/releases/download/${TERMUX_PKG_VERSION}/exfatprogs-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=455e7e651cd0e7ef06d7a0f0dda4f50e21697ec6c4f77f6a152a90c3862f81b3
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CFLAGS+=" -D_FILE_OFFSET_BITS=64"
	CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
}
