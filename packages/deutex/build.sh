TERMUX_PKG_HOMEPAGE=https://github.com/Doom-Utils/deutex/
TERMUX_PKG_DESCRIPTION="WAD composer for Doom, Heretic, Hexen, and Strife"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.2
TERMUX_PKG_SRCURL=https://github.com/Doom-Utils/deutex/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=10ed0e7a533ec97cb6d03548d4258fbec88852a45b5ea4cf5434376ad4174b5f
TERMUX_PKG_DEPENDS="libpng, zlib"

termux_step_pre_configure() {
	./bootstrap
}
