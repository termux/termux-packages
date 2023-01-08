TERMUX_PKG_HOMEPAGE=https://virgil3d.github.io/
TERMUX_PKG_DESCRIPTION="A virtual 3D GPU for use inside qemu virtual machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.4
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-${TERMUX_PKG_VERSION}/virglrenderer-virglrenderer-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd9a1b12473f4cda8d87e6ba1a6e5714a24355e16b69ed85df5c21bf48f797fa
TERMUX_PKG_DEPENDS="libepoxy, libx11"
TERMUX_PKG_BUILD_DEPENDS="libdrm, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dplatforms=glx"
