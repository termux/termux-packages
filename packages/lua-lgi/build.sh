TERMUX_PKG_HOMEPAGE=https://github.com/lgi-devs/lgi
TERMUX_PKG_DESCRIPTION="Dynamic Lua binding to GObject libraries using GObject-Introspection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.2
TERMUX_PKG_SRCURL=https://github.com/lgi-devs/lgi/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cfc4105482b4730b3a40097c9d9e7e35c46df2fb255370bdeb2f45a886548c4f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libffi, liblua54"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
