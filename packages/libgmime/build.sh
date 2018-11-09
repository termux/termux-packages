TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SHA256=613014ffcd327b3f6b06aa45cf4bf3adc25cd831f14537c4132880022dda7209
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/${TERMUX_PKG_VERSION:0:3}/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib, libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--disable-glibtest
--disable-crypto
"
