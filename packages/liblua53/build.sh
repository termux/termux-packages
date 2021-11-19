TERMUX_PKG_HOMEPAGE=https://www.lua.org/
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter (v5.3.x)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.5
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac
TERMUX_PKG_EXTRA_MAKE_ARGS=linux
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="liblua-dev, liblua (<< 5.3.5-6)"
TERMUX_PKG_REPLACES="liblua-dev, liblua (<< 5.3.5-6)"
TERMUX_PKG_BUILD_DEPENDS="readline"

termux_step_configure() {
	sed -e "s/%VER%/${TERMUX_PKG_VERSION%.*}/g;s/%REL%/${TERMUX_PKG_VERSION}/g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR"/lua.pc.in > lua.pc
}

termux_step_pre_configure() {
	OLDAR="$AR"
	AR+=" rcu"
	CFLAGS+=" -fPIC -DLUA_COMPAT_5_2 -DLUA_COMPAT_UNPACK"
	export MYLDFLAGS=$LDFLAGS
}

termux_step_make_install() {
	make \
		TO_BIN="lua5.3 luac5.3" \
		TO_LIB="liblua5.3.so liblua5.3.so.5.3 liblua5.3.so.${TERMUX_PKG_VERSION}" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$TERMUX_PREFIX" \
		INSTALL_INC="$TERMUX_PREFIX/include/lua5.3" \
		INSTALL_MAN="$TERMUX_PREFIX/share/man/man1" \
		install
	install -Dm600 lua.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua53.pc
}

termux_step_post_make_install() {
	cd "$TERMUX_PREFIX"/share/man/man1
	mv -f lua.1 lua5.3.1
	mv -f luac.1 luac5.3.1
	export AR="$OLDAR"
}
