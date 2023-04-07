TERMUX_PKG_HOMEPAGE=https://github.com/Doom-Utils/deutex/
TERMUX_PKG_DESCRIPTION="WAD composer for Doom, Heretic, Hexen, and Strife"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.2
TERMUX_PKG_SRCURL=https://github.com/Doom-Utils/deutex/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=767e75eb3615bb732947448b81031410e26f808dfc3a099d64a483931fe0b313
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpng, zlib"

termux_step_pre_configure() {
	./bootstrap
}
