TERMUX_PKG_HOMEPAGE=https://yasm.tortall.net/
TERMUX_PKG_DESCRIPTION="Assembler supporting the x86 and AMD64 instruction sets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.tortall.net/projects/yasm/releases/yasm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BREAKS="yasm-dev"
TERMUX_PKG_REPLACES="yasm-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-nls"
