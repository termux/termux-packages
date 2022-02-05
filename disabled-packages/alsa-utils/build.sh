TERMUX_PKG_HOMEPAGE=http://www.alsa-project.org
TERMUX_PKG_VERSION=1.1.3
TERMUX_PKG_SRCURL=ftp://ftp.alsa-project.org/pub/utils/alsa-utils-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=127217a54eea0f9a49700a2f239a2d4f5384aa094d68df04a8eb80132eb6167c
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-udev-rules-dir=$TERMUX_PREFIX/lib/udev/rules.d --with-asound-state-dir=$TERMUX_PREFIX/var/lib/alsa --disable-bat --disable-rst2man"

termux_step_pre_configure() {
    LDFLAGS+=" -llog"
}
