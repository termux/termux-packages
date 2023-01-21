TERMUX_PKG_HOMEPAGE=https://github.com/anholt/libepoxy
TERMUX_PKG_DESCRIPTION="Library handling OpenGL function pointer management"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/anholt/libepoxy/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15
TERMUX_PKG_DEPENDS="mesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dglx=yes
-Degl=yes
-Dx11=true
-Dtests=false
"
