TERMUX_PKG_HOMEPAGE=http://www.lua.org/
TERMUX_PKG_DESCRIPTION="Powerful, fast, lightweight, embeddable scripting language"
TERMUX_PKG_VERSION=5.3.3
TERMUX_PKG_SRCURL=http://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_EXTRA_MAKE_ARGS=linux
TERMUX_PKG_BUILD_IN_SRC=yes

AR="$AR rcu"
LDFLAGS="$LDFLAGS -lm"
