TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxde-common
TERMUX_PKG_DESCRIPTION="Common files of the LXDE desktop environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.99.4"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxde-common/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5353378efdc295c9be25cf4a3b5783fde4039b8cebbe426cea9cafc2aee3a3c6
TERMUX_PKG_DEPENDS="lxsession, openbox"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--sysconfdir=$TERMUX_PREFIX/etc"

termux_step_pre_configure() {
	./autogen.sh
}
