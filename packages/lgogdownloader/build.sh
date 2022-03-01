TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/gogdownloader/
TERMUX_PKG_DESCRIPTION="Open source downloader to GOG.com for Linux users using the same API as the official GOGDownloader"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Sude-/lgogdownloader/releases/download/v${TERMUX_PKG_VERSION}/lgogdownloader-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f4941f07b94f4e96557ca86f33f7d839042bbcac7535f6f9736092256d31eb5
TERMUX_PKG_DEPENDS="boost, jsoncpp, libc++, libcurl, libhtmlcxx, libtinyxml2, rhash"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DHELP2MAN=OFF"
