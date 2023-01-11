TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/gogdownloader/
TERMUX_PKG_DESCRIPTION="Open source downloader to GOG.com for Linux users using the same API as the official GOGDownloader"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/Sude-/lgogdownloader/releases/download/v${TERMUX_PKG_VERSION}/lgogdownloader-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0b3b6198e687f811294abb887257c5c28396b5af74c7f3843347bf08c68e3d0
TERMUX_PKG_DEPENDS="boost, jsoncpp, libc++, libcurl, libhtmlcxx, libtinyxml2, rhash"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DHELP2MAN=OFF"
