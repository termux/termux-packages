TERMUX_PKG_HOMEPAGE=http://liba52.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A free library for decoding ATSC A/52 streams"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_REVISION=2
# FIXME: GitHub Action got banned by distfiles.adelielinux.org, see #24930.
# FIXME: Use one mirror in https://www.adelielinux.org/mirrors/ instead.
# TERMUX_PKG_SRCURL=https://distfiles.adelielinux.org/source/a52dec/a52dec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://plug-mirror.rcac.purdue.edu/adelie/source/a52dec/a52dec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=03c181ce9c3fe0d2f5130de18dab9bd8bc63c354071515aa56983c74a9cffcc9
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-djbfft
--disable-oss
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -lm"
}
