TERMUX_PKG_HOMEPAGE=https://github.com/anholt/libepoxy
TERMUX_PKG_DESCRIPTION="Library handling OpenGL function pointer management"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.5.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/anholt/libepoxy/releases/download/${TERMUX_PKG_VERSION}/libepoxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9479cc0146ffb395fdecf9bd2a5930834fd0bce490cbcc4681ffd716bb3a0763
TERMUX_PKG_DEPENDS="mesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dglx=yes
-Degl=no
-Dx11=true
-Dtests=false
"
