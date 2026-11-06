TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxinput
TERMUX_PKG_DESCRIPTION="Small program to configure keyboard and mouse for LXDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.3.6"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxinput/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f15c2a17f970afb152cbd024503da26c1e15135e76e9f516e0ca97e909d6c37
TERMUX_PKG_DEPENDS="glib, gtk3, libx11, xorg-xmodmap, xorg-xset"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"

termux_step_pre_configure() {
	./autogen.sh
}
