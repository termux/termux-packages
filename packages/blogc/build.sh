TERMUX_PKG_HOMEPAGE=https://blogc.rgm.io/
TERMUX_PKG_DESCRIPTION="A blog compiler"
TERMUX_PKG_VERSION=0.13.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_MAINTAINER="Rafael Martins @rafaelmartins"
TERMUX_PKG_SRCURL="https://github.com/blogc/blogc/releases/download/v${TERMUX_PKG_VERSION}/blogc-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e942648e6bd76b1fa51d3d9f4d5bffbc4fa2a6ce08d27e6f6fd09f4ce24a34af
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-git-receiver --enable-make --enable-runserver --disable-tests --disable-valgrind"
