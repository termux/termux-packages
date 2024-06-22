TERMUX_PKG_HOMEPAGE=https://github.com/cernekee/stoken
TERMUX_PKG_DESCRIPTION="Software Token for Linux/UNIX"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.93"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/cernekee/stoken/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=102e2d112b275efcdc20ef438670e4f24f08870b9072a81fda316efcc38aef9c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libnettle, libxml2"

termux_step_pre_configure() {
	autoreconf -fi
	LDFLAGS+=" -Wl,-undefined-version"
}
