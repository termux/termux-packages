TERMUX_PKG_HOMEPAGE=http://strophe.im/libstrophe/
TERMUX_PKG_DESCRIPTION="libstrophe is a minimal XMPP library written in C"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/strophe/libstrophe/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=libstrophe-$TERMUX_PKG_VERSION
# Would also work with libxml2
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
./bootstrap.sh
}
