TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/gogdownloader/
TERMUX_PKG_DESCRIPTION="Open source downloader to GOG.com for Linux users using the same API as the official GOGDownloader"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.20"
TERMUX_PKG_SRCURL="https://github.com/Sude-/lgogdownloader/releases/download/v${TERMUX_PKG_VERSION}/lgogdownloader-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=14dbbaf7d6764143444dbb5be8a53d8fdea6d8647204e05ed81f8dd5e80a4fde
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, jsoncpp, libc++, libcurl, libhtmlcxx, libtinyxml2, rhash, tidy"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DHELP2MAN=OFF"

termux_step_pre_configure() {
	# ld.lld: error: undefined symbol: Json::Value::operator[](char const*)
	CXXFLAGS+=" -DJSONCPP_HAS_STRING_VIEW=1"
}
