TERMUX_PKG_HOMEPAGE=https://github.com/anholt/libepoxy
TERMUX_PKG_DESCRIPTION="Library handling OpenGL function pointer management"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/anholt/libepoxy/releases/download/${TERMUX_PKG_VERSION}/libepoxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cf05e4901778c434aef68bb7dc01bea2bce15440c0cecb777fb446f04db6fe0d
TERMUX_PKG_DEPENDS="mesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dglx=yes
-Degl=no
-Dx11=true
-Dtests=false
"
