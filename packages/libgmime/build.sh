TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.2.6
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/${TERMUX_PKG_VERSION:0:3}/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=abff194c7c4802fba2e233890d09dde8bf7170c3ad5e13000601c8d5b3c44717
TERMUX_PKG_DEPENDS="glib, libffi, libiconv, libidn2, zlib"
TERMUX_PKG_BREAKS="libgmime-dev"
TERMUX_PKG_REPLACES="libgmime-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--with-libiconv=gnu
--disable-glibtest
--disable-crypto
"
