TERMUX_PKG_HOMEPAGE=https://github.com/Doom-Utils/deutex/
TERMUX_PKG_DESCRIPTION="WAD composer for Doom, Heretic, Hexen, and Strife"
TERMUX_PKG_VERSION=5.1.2
TERMUX_PKG_SHA256=b91b1cd40098cc8f5e1e9a18ea4b5b785a4f54ff2ce5c6d9524f22ca84a83bd0
TERMUX_PKG_SRCURL=https://github.com/Doom-Utils/deutex/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libpng"
TERMUX_PKG_BUILD_DEPENDS="libpng-dev"

termux_step_pre_configure() {
	./bootstrap
}
