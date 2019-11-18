TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.6.11
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=29751581c8549562957940e68f0b9410a499616c91c1768195bc02def13f5a85

TERMUX_PKG_DEPENDS="atk, c-ares, desktop-file-utils, gdk-pixbuf, glib, gtk3, hicolor-icon-theme, krb5, libandroid-shmem, libcairo, libgcrypt, libgnutls, libgpg-error, liblua52, liblz4, libmaxminddb, libnghttp2, libnl, libpcap, libssh, libxml2, pango, zlib"
TERMUX_PKG_CONFLICTS="tshark, wireshark, wireshark-cli"
TERMUX_PKG_PROVIDES="tshark, wireshark, wireshark-cli"
TERMUX_PKG_REPLACES="tshark, wireshark, wireshark-cli"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3 --with-qt=no"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export CFLAGS=$(echo $CFLAGS | sed 's@-Oz@-Os@g')
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
