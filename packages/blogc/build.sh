TERMUX_PKG_HOMEPAGE=https://blogc.rgm.io/
TERMUX_PKG_DESCRIPTION="A blog compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Rafael Martins @rafaelmartins"
TERMUX_PKG_VERSION=0.16.1
TERMUX_PKG_SHA256=e74214f29de904a776eb8aebd6648947ea45545b40da8cd0f21328884fd47d3d
TERMUX_PKG_SRCURL=https://github.com/blogc/blogc/releases/download/v$TERMUX_PKG_VERSION/blogc-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-git-receiver --enable-make --enable-runserver --disable-tests --disable-valgrind"
