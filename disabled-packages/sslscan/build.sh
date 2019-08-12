# Status: Does not work with openssl 1.1 or later.
TERMUX_PKG_HOMEPAGE=https://github.com/rbsec/sslscan
TERMUX_PKG_DESCRIPTION="Fast SSL scanner"
TERMUX_PKG_VERSION=1.11.11
TERMUX_PKG_SRCURL=https://github.com/rbsec/sslscan/archive/${TERMUX_PKG_VERSION}-rbsec.tar.gz
TERMUX_PKG_SHA256=93fbe1570073dfb2898a546759836ea4df5054e3a8f6d2e3da468eddac8b1764
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU=1"
}
