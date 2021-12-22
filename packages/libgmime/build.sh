TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.7
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/${TERMUX_PKG_VERSION:0:3}/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2aea96647a468ba2160a64e17c6dc6afe674ed9ac86070624a3f584c10737d44
TERMUX_PKG_DEPENDS="glib, libffi, libiconv, libidn2, zlib"
TERMUX_PKG_BREAKS="libgmime-dev"
TERMUX_PKG_REPLACES="libgmime-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--with-libiconv=gnu
--disable-glibtest
--disable-crypto
"

termux_step_pre_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR"/iconv-detect.h ./
}
