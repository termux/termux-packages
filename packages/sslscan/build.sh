TERMUX_PKG_HOMEPAGE=https://github.com/rbsec/sslscan
TERMUX_PKG_DESCRIPTION="Fast SSL scanner"
TERMUX_PKG_VERSION=1.11.10
TERMUX_PKG_SRCURL=https://github.com/rbsec/sslscan/archive/${TERMUX_PKG_VERSION}-rbsec.tar.gz
TERMUX_PKG_SHA256=fbb26fdbf2cf5b2f3f8c88782721b7875f206552cf83201981411e0af9521204
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU=1"
}
