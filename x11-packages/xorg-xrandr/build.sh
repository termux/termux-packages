TERMUX_PKG_HOMEPAGE="https://xorg.freedesktop.org/"
TERMUX_PKG_DESCRIPTION="Primitive command line interface to RandR extension"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/xorg/app/xrandr/-/archive/xrandr-${TERMUX_PKG_VERSION}/xrandr-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256="ca4d5083c86660cb00b465365aab738bcdb310ee9715ad2cf1571f679226229e"
TERMUX_PKG_DEPENDS="libx11, libxrandr"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xorgproto"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
