TERMUX_PKG_HOMEPAGE=https://strophe.im/libstrophe
TERMUX_PKG_DESCRIPTION="libstrophe is a minimal XMPP library written in C."
TERMUX_PKG_LICENSE="MIT, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.1"
TERMUX_PKG_SRCURL=https://github.com/strophe/libstrophe/releases/download/${TERMUX_PKG_VERSION}/libstrophe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7b78202d88bf7e4c1f86eb547300e90587d09d22ed2724e47183ca677080175a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, libexpat, c-ares"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cares"

termux_step_pre_configure() {
	./bootstrap.sh
}
