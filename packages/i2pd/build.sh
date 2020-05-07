TERMUX_PKG_HOMEPAGE=https://i2pd.website/
TERMUX_PKG_DESCRIPTION="A full-featured C++ implementation of the I2P router"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=2.31.0
TERMUX_PKG_SRCURL=https://github.com/PurpleI2P/i2pd/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7e37abcf49e9f59ef6939069f4d74fc6bf29b09deec111bd3561021fc1349528
TERMUX_PKG_DEPENDS="boost, miniupnpc, openssl, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_UPNP:BOOL=ON"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/build"
	CXXFLAGS="${CXXFLAGS/-Oz/-O2}"
}
