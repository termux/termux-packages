TERMUX_PKG_HOMEPAGE=http://bs2b.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Bauer stereophonic-to-binaural DSP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/bs2b/libbs2b-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4799974becdeeedf0db00115bc63f60ea3fe4b25f1dfdb6903505839a720e46f
TERMUX_PKG_DEPENDS="libc++, libsndfile"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
