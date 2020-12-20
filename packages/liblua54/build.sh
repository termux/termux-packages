TERMUX_PKG_HOMEPAGE=https://www.lua.org/
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.2
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=11570d97e9d7303c0a59567ed1ac7c648340cd0db10d5fd594c09223ef2f524f
TERMUX_PKG_EXTRA_MAKE_ARGS=linux
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="liblua-dev"
TERMUX_PKG_REPLACES="liblua-dev"
TERMUX_PKG_BUILD_DEPENDS="readline"

termux_step_configure() {
	sed -e "s/%VER%/${TERMUX_PKG_VERSION%.*}/g;s/%REL%/${TERMUX_PKG_VERSION}/g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR"/lua.pc.in > lua.pc
}

termux_step_pre_configure() {
	AR+=" rcu"
	CFLAGS+=" -fPIC -DLUA_COMPAT_5_2 -DLUA_COMPAT_UNPACK"
	export MYLDFLAGS=$LDFLAGS
}

termux_step_make_install() {
	make \
		TO_BIN="lua5.4 luac5.4" \
		TO_LIB="liblua5.4.so liblua5.4.so.5.4 liblua5.4.so.${TERMUX_PKG_VERSION}" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$TERMUX_PREFIX" \
		INSTALL_INC="$TERMUX_PREFIX/include/lua5.4" \
		INSTALL_MAN="$TERMUX_PREFIX/share/man/man1" \
		install
	install -Dm600 lua.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua54.pc

	mv -f "$TERMUX_PREFIX"/share/man/man1/lua.1 "$TERMUX_PREFIX"/share/man/man1/lua5.4.1
	mv -f "$TERMUX_PREFIX"/share/man/man1/luac.1 "$TERMUX_PREFIX"/share/man/man1/luac5.4.1
}
