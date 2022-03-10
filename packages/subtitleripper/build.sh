TERMUX_PKG_HOMEPAGE=http://subtitleripper.sourceforge.net/
TERMUX_PKG_DESCRIPTION="DVD subtitle ripper for Linux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=0.3-4
TERMUX_PKG_VERSION=${_VERSION//-/.}
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/subtitleripper/subtitleripper-${_VERSION}.tgz
TERMUX_PKG_SHA256=8af6c2ebe55361900871c731ea1098b1a03efa723cd29ee1d471435bd21f3ac4
TERMUX_PKG_DEPENDS="libpng, netpbm, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DHAVE_GETLINE"
	CFLAGS+=" $CPPFLAGS"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin \
		srttool subtitle2pgm subtitle2vobsub vobsub2pgm
}
