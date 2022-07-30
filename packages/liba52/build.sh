TERMUX_PKG_HOMEPAGE=http://liba52.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A free library for decoding ATSC A/52 streams"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.4
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=http://liba52.sourceforge.net/files/a52dec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a21d724ab3b3933330194353687df82c475b5dfb997513eef4c25de6c865ec33
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-djbfft
--disable-oss
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -lm"
}
