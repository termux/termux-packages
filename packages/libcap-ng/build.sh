TERMUX_PKG_HOMEPAGE=https://people.redhat.com/sgrubb/libcap-ng/
TERMUX_PKG_DESCRIPTION="Library making programming with POSIX capabilities easier than traditional libcap"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:0.9"
TERMUX_PKG_SRCURL=https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=d7463da4b50924a385e306f585bb05dbe58e212ba846f8593c3b2bd31c6cb46b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-python
--without-python3
"

termux_step_pre_configure() {
	./autogen.sh
}
