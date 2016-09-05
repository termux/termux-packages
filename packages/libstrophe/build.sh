TERMUX_PKG_HOMEPAGE=http://strophe.im/libstrophe/
TERMUX_PKG_DESCRIPTION="libstrophe is a minimal XMPP library written in C"
TERMUX_PKG_VERSION=0.8.20160905
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
# Using latest commit because since 0.8.8 it has been somewhat optimized for compilation on Android
_COMMIT=936ddb0d150ba3705e7190be274761331ef4fdca
TERMUX_PKG_SRCURL=https://github.com/strophe/libstrophe/archive/${_COMMIT}.tar.gz
TERMUX_PKG_FOLDERNAME=libstrophe-$_COMMIT
# Would also work with libxml2
TERMUX_PKG_DEPENDS="openssl,libexpat"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
./bootstrap.sh
}
