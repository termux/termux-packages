TERMUX_PKG_HOMEPAGE=https://github.com/boothj5/libmesode
TERMUX_PKG_DESCRIPTION="Minimal XMPP library written for use with Profanity XMPP client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/boothj5/libmesode/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=79bdf92e287d8891a8eb89d84a8b1bb1c3f61ded322630f583ec1d1c00d99123
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BREAKS="libmesode-dev"
TERMUX_PKG_REPLACES="libmesode-dev"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
./bootstrap.sh
}
