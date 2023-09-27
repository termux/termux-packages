TERMUX_PKG_HOMEPAGE=http://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Pattern-matching library for Lua 5.3"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a
TERMUX_PKG_DEPENDS="liblua53"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make \
		CC="$CC" \
		CFLAGS="$CFLAGS -fPIC -I$TERMUX_PREFIX/include/lua5.3" \
		LDFLAGS="$LDFLAGS -L$TERMUX_PREFIX/lib/lua/5.3 -llua5.3" \
		LUADIR="$TERMUX_PREFIX"/include/lua/5.3
}

termux_step_make_install() {
	install -Dm600 lpeg.so "$TERMUX_PREFIX"/lib/lua/5.3/lpeg.so
	install -Dm600 re.lua "$TERMUX_PREFIX"/share/lua/5.3/re.lua
}
