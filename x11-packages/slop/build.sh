TERMUX_PKG_HOMEPAGE=https://github.com/naelstrof/slop
TERMUX_PKG_DESCRIPTION="Queries for a selection from the user and prints the region to stdout"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@Keytaro2"
TERMUX_PKG_VERSION=7.7
TERMUX_PKG_SRCURL="https://github.com/naelstrof/slop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a69a6e5c41d7fff1c6aa35b367a5c5a6dc98e621fa9a1908808d6308c2b40f4e
TERMUX_PKG_DEPENDS="libicu, libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="glm, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSLOP_OPENGL=OFF
-DSLOP_UNICODE=ON
"
