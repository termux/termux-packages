TERMUX_PKG_HOMEPAGE=http://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Pattern-matching library for Lua 5.3"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe
TERMUX_PKG_DEPENDS="liblua"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make \
		CC="$CC" \
		CFLAGS="$CFLAGS -fPIC" \
		LDFLAGS="$LDFLAGS -llua" \
		LUADIR="$TERMUX_PREFIX"/include
}

termux_step_make_install() {
	install -Dm600 lpeg.so "$TERMUX_PREFIX"/lib/lua/5.3/lpeg.so
	install -Dm600 re.lua "$TERMUX_PREFIX"/share/lua/5.3/re.lua
}
