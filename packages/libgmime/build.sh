TERMUX_PKG_HOMEPAGE=http://spruce.sourceforge.net/gmime/
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
TERMUX_PKG_VERSION=3.0.2
TERMUX_PKG_SHA256=0deb460111ffa2ec672677da339b82dedeb28b258ccdb216daa21c81a9472fb2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gmime/${TERMUX_PKG_VERSION:0:3}/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib, libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--disable-glibtest
"
