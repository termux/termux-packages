TERMUX_PKG_HOMEPAGE=http://www.lxde.org/
TERMUX_PKG_DESCRIPTION="LXDE monitor configuration tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.3"
TERMUX_PKG_SRCURL="https://github.com/lxde/lxrandr/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=24d0abaee830b0b2973ba9d2e46b3c801445342f7d5d3297c021a8a4a471f512
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="xorg-xrandr, gtk3"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"

termux_step_pre_configure() {
	./autogen.sh
}
