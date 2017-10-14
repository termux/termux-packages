TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server - shared libraries"
TERMUX_PKG_VERSION=11.1
TERMUX_PKG_SHA256=f2521c525a77166189e3cb9169f75c2ee2b82fa3fcf9476024fbc2c3a6c9cd9e
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libltdl, libsndfile, libandroid-glob"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/vala"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt --disable-alsa --disable-esound --disable-glib2 --disable-openssl --without-caps --with-database=simple"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/dafault.pa etc/pulse/system.pa"

termux_step_pre_configure () {
    LDFLAGS+=" -llog -landroid-glob"
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
