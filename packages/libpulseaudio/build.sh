TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server - shared libraries"
TERMUX_PKG_VERSION=10.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a3186824de9f0d2095ded5d0d0db0405dc73133983c2fbb37291547e37462f57
TERMUX_PKG_DEPENDS="libltdl, libsndfile"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/vala"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt --disable-alsa --disable-esound --disable-glib2 --disable-openssl --without-caps --with-database=simple"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/dafault.pa etc/pulse/system.pa"

termux_step_pre_configure () {
    LDFLAGS+=" -llog"
}

termux_step_post_make_install () {
    # Some binaries link against these:
    cd $TERMUX_PREFIX/lib
    for lib in pulseaudio/lib*.so* pulse-${TERMUX_PKG_VERSION}/modules/lib*.so*; do
        ln -s -f $lib `basename $lib`
    done

    # Pulseaudio fails to start when it cannot detect any sound hardware
    # so disable hardware detection.
    sed -i $TERMUX_PREFIX/etc/pulse/default.pa \
        -e '/^load-module module-detect$/s/^/#/'
}
