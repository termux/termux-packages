TERMUX_PKG_HOMEPAGE=https://aubio.org/
TERMUX_PKG_DESCRIPTION="A library to label music and sounds"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.9
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://aubio.org/pub/aubio-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da
TERMUX_PKG_DEPENDS="ffmpeg, libsamplerate, libsndfile"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DFF_API_LAVF_AVCTX"
}

termux_step_configure() {
	./waf configure \
		--prefix=$TERMUX_PREFIX \
		LINKFLAGS="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	./waf
}

termux_step_make_install() {
	./waf install
}
