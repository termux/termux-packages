TERMUX_PKG_HOMEPAGE=http://pidgin.im/
TERMUX_PKG_DESCRIPTION="Text-based multi-protocol instant messaging client"
TERMUX_PKG_VERSION=2.10.12
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/pidgin/Pidgin/${TERMUX_PKG_VERSION}/pidgin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libgnutls, libxml2, ncurses-ui-libs, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtkui --disable-gstreamer --disable-vv --disable-idn --disable-meanwhile --disable-avahi --disable-dbus --disable-perl --disable-tcl --without-zephyr --with-ncurses-headers=$TERMUX_PREFIX/include --without-python"
TERMUX_PKG_RM_AFTER_INSTALL="share/sounds/purple"

# For arpa:
CFLAGS="$CFLAGS -isystem $TERMUX_PKG_BUILDER_DIR"
