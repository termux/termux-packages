TERMUX_PKG_HOMEPAGE=https://github.com/boothj5/libmesode
TERMUX_PKG_DESCRIPTION="libmesode is a minimal XMPP library written in C. Fork of libstrophe for use with Profanity XMPP Client. Provides extra TLS functionality such as manual SSL certificate verfication"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/boothj5/libmesode/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=libmesode-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
./bootstrap.sh
}
