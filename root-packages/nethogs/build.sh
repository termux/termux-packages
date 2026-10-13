TERMUX_PKG_HOMEPAGE=https://github.com/raboof/nethogs
TERMUX_PKG_DESCRIPTION="Net top tool grouping bandwidth per process"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SRCURL=https://github.com/raboof/nethogs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5961bef2155c05695d2fe7e79aa11194981b5afd1cad9bf1f259c7f30d5487c3
TERMUX_PKG_DEPENDS="libc++, ncurses, libpcap"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Denable-libnethogs=disabled"

termux_step_post_get_source() {
	printf '#!/bin/sh\necho %s\n' "${TERMUX_PKG_VERSION}" > determineVersion.sh
}

termux_step_pre_configure() {
	CPPFLAGS+=" -Dindex=strchr -Drindex=strrchr -Dquad_t=int64_t"
}
