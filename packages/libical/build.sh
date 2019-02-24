TERMUX_PKG_HOMEPAGE=http://libical.github.io/libical/
TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=3.0.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=72b216e10233c3f60cb06062facf41f3b0f70615e5a60b47f9853341a0d5d145
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DSHARED_ONLY=true -DICAL_GLIB=false -DUSE_BUILTIN_TZDATA=true -DPERL_EXECUTABLE=/usr/bin/perl"
