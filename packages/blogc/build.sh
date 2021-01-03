TERMUX_PKG_HOMEPAGE=https://blogc.rgm.io/
TERMUX_PKG_DESCRIPTION="A blog compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Rafael Martins @rafaelmartins"
TERMUX_PKG_VERSION=0.20.1
TERMUX_PKG_SRCURL=https://github.com/blogc/blogc/releases/download/v$TERMUX_PKG_VERSION/blogc-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=0ecf95acbe9f90fc35986234c4feb8f860637a703cb50c7d0f054344ab9f6709
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-git-receiver --enable-make --enable-runserver --disable-tests --disable-valgrind"
