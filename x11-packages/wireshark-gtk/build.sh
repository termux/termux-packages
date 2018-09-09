TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=49b2895ee3ba17ef9ef0aebfdc4d32a778e0f36ccadde184516557d5f3357094

TERMUX_PKG_DEPENDS="c-ares, desktop-file-utils, glib, hicolor-icon-theme, libandroid-shmem, libgcrypt, libgnutls, libgtk3, liblua52, liblz4, libmaxminddb, libnghttp2, libnl, libpcap, libssh, libxml2"
TERMUX_PKG_CONFLICTS="tshark, wireshark, wireshark-cli"
TERMUX_PKG_PROVIDES="tshark, wireshark, wireshark-cli"
TERMUX_PKG_REPLACES="tshark, wireshark, wireshark-cli"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    export TERMUX_MAKE_PROCESSES=8
    export CFLAGS=$(echo $CFLAGS | sed 's@-Oz@-O2@g')
    export LIBS=" -landroid-shmem"
}

termux_step_post_configure() {
    ## prebuild libwsutil & libwscodecs for target (needed for plugins/codecs/l16_mono)
    cd ./wsutil && {
        make
        cd -
    }
    cd ./codecs && {
        make
        cd -
    }
}
