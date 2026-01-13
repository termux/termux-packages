TERMUX_PKG_HOMEPAGE="https://freedesktop.org/wiki/Specifications/sound-theme-spec"
TERMUX_PKG_DESCRIPTION="Freedesktop sound theme"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-2.0-or-later, custom" # and some CC-BY and CC-BY-SA
TERMUX_PKG_LICENSE_FILE="CREDITS"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/xdg/xdg-sound-theme/-/archive/${TERMUX_PKG_VERSION}/xdg-sound-theme-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="b3f611d15d9ee48d1dfaa98341d38f169939ed8b99d0b42f96d1d5d8a2d8498c"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="intltool"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fi
}
