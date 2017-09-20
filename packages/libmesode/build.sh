TERMUX_PKG_HOMEPAGE=https://github.com/boothj5/libmesode
TERMUX_PKG_DESCRIPTION="libmesode is a minimal XMPP library written in C. Fork of libstrophe for use with Profanity XMPP Client. Provides extra TLS functionality such as manual SSL certificate verfication"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/boothj5/libmesode/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e693ea1577f0d9e6e58dd8ada9825c359784a225620cbc2fde7295369d295245
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
./bootstrap.sh
}
