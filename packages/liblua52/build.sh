TERMUX_PKG_HOMEPAGE=https://www.lua.org
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter (v5.2.x)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.4
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b9e2e4aad6789b3b63a056d442f7b39f0ecfca3ae0f1fc0ae4e9614401b69f4b
TERMUX_PKG_BREAKS="liblua52-dev"
TERMUX_PKG_REPLACES="liblua52-dev"
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	sed -e "s/%VER%/${TERMUX_PKG_VERSION%.*}/g;s/%REL%/${TERMUX_PKG_VERSION}/g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR"/lua.pc.in > lua.pc
}

termux_step_make() {
	make -j $TERMUX_PKG_MAKE_PROCESSES \
		MYCFLAGS="$CFLAGS -fPIC" \
		MYLDFLAGS="$LDFLAGS" \
		CC="$CC" \
		CXX="$CXX" \
		linux
}

termux_step_make_install() {
	make \
		TO_BIN="lua5.2 luac5.2" \
		TO_LIB="liblua5.2.so liblua5.2.so.5.2 liblua5.2.so.${TERMUX_PKG_VERSION} liblua5.2.a" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$TERMUX_PREFIX" \
		INSTALL_INC="$TERMUX_PREFIX/include/lua5.2" \
		INSTALL_MAN="$TERMUX_PREFIX/share/man/man1" \
		install
	install -Dm600 lua.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua52.pc

	mv -f "$TERMUX_PREFIX"/share/man/man1/lua.1 "$TERMUX_PREFIX"/share/man/man1/lua5.2.1
	mv -f "$TERMUX_PREFIX"/share/man/man1/luac.1 "$TERMUX_PREFIX"/share/man/man1/luac5.2.1
}
