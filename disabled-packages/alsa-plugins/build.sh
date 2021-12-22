TERMUX_PKG_HOMEPAGE=http://www.alsa-project.org
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=8ea4d1e082c36528a896a2581e5eb62d4dc2683238e353050d0d624e65f901f1
TERMUX_PKG_DEPENDS="alsa-lib, pulseaudio"
TERMUX_PKG_EXTRA_MAKE_ARGS='SUBDIRS=pulse'

termux_step_post_make_install() {
    cp $TERMUX_PKG_BUILDER_DIR/asound.conf $TERMUX_PREFIX/etc
}
