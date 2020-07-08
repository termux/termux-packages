TERMUX_PKG_HOMEPAGE=https://www.opus-codec.org/
TERMUX_PKG_DESCRIPTION="A high-level API for decoding and seeking within .opus files"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=0.11
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/xiph/opusfile/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c2105cffc59545ffc0d2a65069e2f222a1712bbe579911ac0a3d3660edbbec57
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libopus, libogg"
TERMUX_PKG_BREAKS="opusfile-dev"
TERMUX_PKG_REPLACES="opusfile-dev"

termux_step_pre_configure() {
	echo "PACKAGE_VERSION=$TERMUX_PKG_VERSION" > package_version
	./autogen.sh
}
