TERMUX_PKG_HOMEPAGE=https://www.lua.org
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter (v5.1.x)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1.5
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
}

termux_step_configure() {
	sed -e "s/%VER%/${TERMUX_PKG_VERSION%.*}/g;s/%REL%/${TERMUX_PKG_VERSION}/g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR"/lua.pc.in > lua.pc
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		MYCFLAGS="$CFLAGS" \
		MYLDFLAGS="$LDFLAGS" \
		CC="$CC" \
		CXX="$CXX" \
		linux
}

termux_step_make_install() {
	make \
		TO_BIN="lua5.1 luac5.1" \
		TO_LIB="liblua5.1.so liblua5.1.so.5.1 liblua5.1.so.${TERMUX_PKG_VERSION} liblua5.1.a" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$TERMUX_PREFIX" \
		INSTALL_INC="$TERMUX_PREFIX/include/lua5.1" \
		INSTALL_MAN="$TERMUX_PREFIX/share/man/man1" \
		install
	install -Dm600 lua.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua51.pc

	mv -f "$TERMUX_PREFIX"/share/man/man1/lua.1 "$TERMUX_PREFIX"/share/man/man1/lua5.1.1
	mv -f "$TERMUX_PREFIX"/share/man/man1/luac.1 "$TERMUX_PREFIX"/share/man/man1/luac5.1.1
}
