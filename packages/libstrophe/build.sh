TERMUX_PKG_HOMEPAGE=https://strophe.im/libstrophe
TERMUX_PKG_DESCRIPTION="libstrophe is a minimal XMPP library written in C."
TERMUX_PKG_LICENSE="MIT, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/strophe/libstrophe/releases/download/${TERMUX_PKG_VERSION}/libstrophe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4918c47029ecdea2deab4b0f9336ca4a8bb12c28b72b2cec397d98664b94c771
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, libexpat, c-ares"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cares"

termux_step_pre_configure() {
	./bootstrap.sh
}
