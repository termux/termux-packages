TERMUX_PKG_HOMEPAGE=https://linuxtv.org

TERMUX_PKG_DESCRIPTION="Userspace tools and conversion library for Video 4 Linux"

TERMUX_PKG_LICENSE="GPL-2.0"

TERMUX_PKG_MAINTAINER="@reactormonk"

TERMUX_PKG_VERSION=20.0

TERMUX_PKG_SRCURL=https://github.com/lineage-rpi/android_external_v4l-utils/archive/refs/heads/lineage-20.0.zip

TERMUX_PKG_SHA256=2d39e98fafd3180299f17ae2bb58f6e665202b07e6a0a8f872936a02fec081af

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-libudev --with-udevdir=/data/data/com.termux/files/lib/udev"

TERMUX_PKG_DEPENDS="argp,libandroid-glob,ndk-multilib"

termux_step_pre_configure() {
    CFLAGS+=" -DANDROID"
    CPPFLAGS+=" -DANDROID"
    mv android-config.h include/
#     sed --in-place -e "s/-lrt//" configure.ac
    shopt -s globstar
    sed --in-place -e "s/-lrt//" -- **/Makefile.am
    sed --in-place -e "s/-lrt//" -- **/*.pc.in
    sed --in-place -e "s/-lrt//" -- **/*.pro
    sed --in-place -e "s/-lpthread//" -- **/Makefile.am
    shopt -u globstar

#     # borrowed from memcached
#     # cp $TERMUX_PKG_BUILDER_DIR/getsubopt.c $TERMUX_PKG_SRCDIR
#     # cp $TERMUX_PKG_BUILDER_DIR/getsubopt.h $TERMUX_PKG_SRCDIR

    autoreconf -fi
}
