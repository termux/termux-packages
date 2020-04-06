TERMUX_PKG_HOMEPAGE=https://github.com/boothj5/libmesode
TERMUX_PKG_DESCRIPTION="Minimal XMPP library written for use with Profanity XMPP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.9.3
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/boothj5/libmesode/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=746e0646a9176a303a07ec8ed7c443a38416acc743ed19eeddf6a89d97209ffd
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BREAKS="libmesode-dev"
TERMUX_PKG_REPLACES="libmesode-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
./bootstrap.sh
}
