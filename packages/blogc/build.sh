TERMUX_PKG_HOMEPAGE=https://blogc.rgm.io/
TERMUX_PKG_DESCRIPTION="A blog compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Rafael Martins @rafaelmartins"
TERMUX_PKG_VERSION=0.19.0
TERMUX_PKG_SRCURL=https://github.com/blogc/blogc/releases/download/v$TERMUX_PKG_VERSION/blogc-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=41d9b626ce3096558af143fae9a99ebedd72cec667e6e1f0caee8d5c1d349985
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-git-receiver --enable-make --enable-runserver --disable-tests --disable-valgrind"
