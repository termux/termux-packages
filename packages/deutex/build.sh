TERMUX_PKG_HOMEPAGE=https://github.com/Doom-Utils/deutex/
TERMUX_PKG_DESCRIPTION="WAD composer for Doom, Heretic, Hexen, and Strife"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.2.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Doom-Utils/deutex/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=74bc442169623d5b35dd5c62d8d1747da4358a6d499a6c8a21e6a71c3cf97e98
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpng, zlib"

termux_step_pre_configure() {
	./bootstrap
}
