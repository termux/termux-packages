TERMUX_PKG_HOMEPAGE=https://github.com/anholt/libepoxy
TERMUX_PKG_DESCRIPTION="Library handling OpenGL function pointer management"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.5.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/anholt/libepoxy/releases/download/${TERMUX_PKG_VERSION}/libepoxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=002958c5528321edd53440235d3c44e71b5b1e09b9177e8daf677450b6c4433d
TERMUX_PKG_DEPENDS="mesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dglx=yes
-Degl=no
-Dx11=true
-Dtests=false
"
