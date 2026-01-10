TERMUX_PKG_HOMEPAGE=https://www.lua.org/
TERMUX_PKG_DESCRIPTION="Shared library for the Lua interpreter (v5.5.x)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=57ccc32bbbd005cab75bcc52444052535af691789dba2b9016d5c50640d68b3d
TERMUX_PKG_EXTRA_MAKE_ARGS=linux
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="liblua-dev, liblua55"
TERMUX_PKG_REPLACES="liblua-dev, liblua55"
TERMUX_PKG_BUILD_DEPENDS="readline"

termux_step_configure() {
	sed -e "s/%VER%/${TERMUX_PKG_VERSION%.*}/g;s/%REL%/${TERMUX_PKG_VERSION}/g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR"/lua.pc.in > lua.pc
}

termux_step_pre_configure() {
	OLDAR="$AR"
	AR+=" rcu"
	CFLAGS+=" -fPIC"
	export MYLDFLAGS=$LDFLAGS
}

termux_step_make_install() {
	make \
		TO_BIN="lua5.5 luac5.5" \
		TO_LIB="liblua5.5.so liblua5.5.so.5.5 liblua5.5.so.${TERMUX_PKG_VERSION} liblua5.5.a" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$TERMUX_PREFIX" \
		INSTALL_INC="$TERMUX_PREFIX/include/lua5.5" \
		INSTALL_MAN="$TERMUX_PREFIX/share/man/man1" \
		install
	install -Dm600 lua.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua55.pc
	ln -sf lua55.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua5.5.pc
	ln -sf lua55.pc "$TERMUX_PREFIX"/lib/pkgconfig/lua-5.5.pc
}

termux_step_post_make_install() {
	cd "$TERMUX_PREFIX"/share/man/man1
	mv -f lua.1 lua5.5.1
	mv -f luac.1 luac5.5.1
	export AR="$OLDAR"
}
