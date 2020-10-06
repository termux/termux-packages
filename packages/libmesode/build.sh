TERMUX_PKG_HOMEPAGE=https://github.com/boothj5/libmesode
TERMUX_PKG_DESCRIPTION="Minimal XMPP library written for use with Profanity XMPP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/boothj5/libmesode/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ddf50aaaf778e039b0c00b69f40f3d51238418e09b7c674c6388fedcac48adf9
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BREAKS="libmesode-dev"
TERMUX_PKG_REPLACES="libmesode-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
./bootstrap.sh
}
