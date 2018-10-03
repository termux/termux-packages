TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://github.com/anholt/libepoxy
TERMUX_PKG_DESCRIPTION="Library handling OpenGL function pointer management"
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/anholt/libepoxy/releases/download/${TERMUX_PKG_VERSION}/libepoxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a9562386519eb3fd7f03209f279f697a8cba520d3c155d6e253c3e138beca7d8
TERMUX_PKG_DEPENDS="mesa"

termux_step_pre_configure () {
    export EGL_CFLAGS=${CFLAGS}
    export EGL_LIBS="-L${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/lib -lEGL"
}
