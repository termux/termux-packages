TERMUX_PKG_HOMEPAGE=https://blogc.rgm.io/
TERMUX_PKG_DESCRIPTION="A blog compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Rafael Martins @rafaelmartins"
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_SHA256=c414625ee67b9b8e48bcc22b9f2463bf44368db4802200d798d55d7e176a1675
TERMUX_PKG_SRCURL=https://github.com/blogc/blogc/releases/download/v$TERMUX_PKG_VERSION/blogc-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-git-receiver --enable-make --enable-runserver --disable-tests --disable-valgrind"
