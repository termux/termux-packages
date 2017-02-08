TERMUX_PKG_HOMEPAGE=http://www.alsa-project.org
TERMUX_PKG_VERSION=1.1.3
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_SRCURL=ftp://ftp.alsa-project.org/pub/utils/alsa-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=127217a54eea0f9a49700a2f239a2d4f5384aa094d68df04a8eb80132eb6167c
TERMUX_PKG_DEPENDS="alsa-lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-alsa-prefix=$TERMUX_PREFIX/lib --with-alsa-inc-prefix=$TERMUX_PREFIX/include --with-udev-rules-dir=$TERMUX_PREFIX/lib/udev/rules.d --disable-bat"

termux_step_pre_configure () {
    LDFLAGS+=" -llog"
}
