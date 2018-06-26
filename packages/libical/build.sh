TERMUX_PKG_HOMEPAGE=http://libical.github.io/libical/
TERMUX_PKG_DESCRIPTION="Libical is an Open Source implementation of the iCalendar protocols and protocol data units"
TERMUX_PKG_VERSION=3.0.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=5b91eb8ad2d2dcada39d2f81d5e3ac15895823611dc7df91df39a35586f39241
TERMUX_PKG_SRCURL=https://github.com/libical/libical/releases/download/v$TERMUX_PKG_VERSION/libical-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DSHARED_ONLY=true -DICAL_GLIB=false -DUSE_BUILTIN_TZDATA=true -DPERL_EXECUTABLE=/usr/bin/perl"
