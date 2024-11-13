TERMUX_PKG_HOMEPAGE=https://www.pixman.org/
TERMUX_PKG_DESCRIPTION="Low-level library for pixel manipulation"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.44.0"
TERMUX_PKG_SRCURL=https://cairographics.org/releases/pixman-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89a4c1e1e45e0b23dffe708202cb2eaffde0fe3727d7692b2e1739fec78a7dac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libpixman-dev"
TERMUX_PKG_REPLACES="libpixman-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dlibpng=disabled"
