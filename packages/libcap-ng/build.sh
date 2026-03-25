TERMUX_PKG_HOMEPAGE=https://people.redhat.com/sgrubb/libcap-ng/
TERMUX_PKG_DESCRIPTION="Library making programming with POSIX capabilities easier than traditional libcap"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:0.9.2"
TERMUX_PKG_SRCURL=https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=df6910d996818848de92db9c05f96492e008c4e35f96a8673f9b7cc44f5cf813
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-python
--without-python3
"

termux_step_pre_configure() {
	./autogen.sh
}
