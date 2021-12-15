TERMUX_PKG_HOMEPAGE=https://github.com/boothj5/libmesode
TERMUX_PKG_DESCRIPTION="Minimal XMPP library written for use with Profanity XMPP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/boothj5/libmesode/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c9dd90648e73d92b90f2b0ae41a75d8f469b116d3e6aa297c14cd57be937d99e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BREAKS="libmesode-dev"
TERMUX_PKG_REPLACES="libmesode-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
./bootstrap.sh
}
