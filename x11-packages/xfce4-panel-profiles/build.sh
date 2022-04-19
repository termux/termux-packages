TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-panel-profiles/start
TERMUX_PKG_DESCRIPTION="A simple application to manage Xfce panel layouts."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.0.13
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-panel-profiles/${TERMUX_PKG_VERSION:0:3}/xfce4-panel-profiles-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=bc387c13f94109422dc72b0fcb919b0dc11619ba589d03e492252b0d2513b170
TERMUX_PKG_DEPENDS="xfce4-panel, python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
    sed -e s,@prefix@,$TERMUX_PREFIX, Makefile.in.in > Makefile.in
    sed \
    -e s,@appname@,xfce4-panel-profiles,g \
    -e s,@version@,$TERMUX_PKG_VERSION,g \
    -e s,@mandir@,$TERMUX_PREFIX/share/man,g \
    -e s,@docdir@,$TERMUX_PREFIX/share/doc/xfce4-panel-profiles,g \
    -e s,@python@,$TERMUX_PREFIX/bin/python,g \
     Makefile.in > Makefile
}
