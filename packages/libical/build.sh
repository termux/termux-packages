TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DSHARED_ONLY=true -DICAL_GLIB=false"
