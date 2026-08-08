TERMUX_PKG_HOMEPAGE=https://www.lua.org/
TERMUX_PKG_DESCRIPTION="Lua scripting language 5.3.x"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.6
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL="https://www.lua.org/ftp/lua-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="liblua-dev, liblua53"
TERMUX_PKG_REPLACES="liblua-dev, liblua53"
TERMUX_PKG_BUILD_DEPENDS="readline"

termux_step_pre_configure() {
	OLDAR="$AR"
	AR+=" rcu"

	# Make a copy of the source tree to build liblua++ from
	cp -vrf \
		"${TERMUX_PKG_SRCDIR}" \
		"${TERMUX_PKG_TMPDIR}/lua++-${TERMUX_PKG_VERSION}"
}

termux_step_configure() {
	# Prepare pkgconfig files
	sed -e "s|%VER%|${TERMUX_PKG_VERSION%.*}|g" \
		-e "s|%REL%|${TERMUX_PKG_VERSION}|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR/lua.pc.in" \
		> lua.pc

	sed -e "s|%VER%|${TERMUX_PKG_VERSION%.*}|g" \
		-e "s|%REL%|${TERMUX_PKG_VERSION}|g" \
		-e "s|-llua|-llua++|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$TERMUX_PKG_BUILDER_DIR/lua.pc.in" \
		> "${TERMUX_PKG_TMPDIR}/lua++-${TERMUX_PKG_VERSION}/lua++.pc"
}

termux_step_make() {
	local LUA_VERSION="${TERMUX_PKG_VERSION%.*}"

	# Build Lua 5.3
	make -j "$TERMUX_PKG_MAKE_PROCESSES" \
		MYCFLAGS="$CFLAGS -fPIC" \
		MYLDFLAGS="$LDFLAGS" \
		LUA_A="liblua${LUA_VERSION}.a"\
		LUA_SO="liblua${LUA_VERSION}.so"\
		linux

	# Build liblua++
	cd "${TERMUX_PKG_TMPDIR}/lua++-${TERMUX_PKG_VERSION}" && \
	make -j "$TERMUX_PKG_MAKE_PROCESSES" \
		CC="$CXX" \
		MYCFLAGS="$CXXFLAGS -fPIC" \
		MYLDFLAGS="$LDFLAGS" \
		LUA_A="liblua++${LUA_VERSION}.a" \
		LUA_SO="liblua++${LUA_VERSION}.so" \
		linux
}

termux_step_make_install() {
	local LUA_VERSION="${TERMUX_PKG_VERSION%.*}"

	# Install Lua 5.3
	make \
		TO_BIN="lua${LUA_VERSION} luac${LUA_VERSION}" \
		TO_LIB="liblua${LUA_VERSION}.so liblua${LUA_VERSION}.so.${LUA_VERSION} liblua${LUA_VERSION}.so.${TERMUX_PKG_VERSION} liblua${LUA_VERSION}.a" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$TERMUX_PREFIX" \
		INSTALL_INC="$TERMUX_PREFIX/include/lua${LUA_VERSION}" \
		INSTALL_MAN="$TERMUX_PREFIX/share/man/man1" \
		install

	# Install and symlink pkgconfig files.
	install -vDm600 lua.pc "$TERMUX_PREFIX/lib/pkgconfig/lua${LUA_VERSION/.}.pc"
	ln -vsf "lua${LUA_VERSION/.}.pc" "$TERMUX_PREFIX/lib/pkgconfig/lua${LUA_VERSION}.pc"
	ln -vsf "lua${LUA_VERSION/.}.pc" "$TERMUX_PREFIX/lib/pkgconfig/lua-${LUA_VERSION}.pc"

	# Same for liblua++
	cd "${TERMUX_PKG_TMPDIR}/lua++-${TERMUX_PKG_VERSION}" && \
	make \
		TO_BIN="lua${LUA_VERSION} luac${LUA_VERSION}" \
		TO_LIB="liblua++${LUA_VERSION}.so liblua++${LUA_VERSION}.so.${LUA_VERSION} liblua++${LUA_VERSION}.so.${TERMUX_PKG_VERSION} liblua++${LUA_VERSION}.a" \
		INSTALL_DATA='cp -d' \
		INSTALL_BIN="null" \
		INSTALL_INC="null" \
		INSTALL_MAN="../null" \
		install

	# Install and symlink liblua++ pkgconfig files.
	install -vDm600 lua++.pc "$TERMUX_PREFIX/lib/pkgconfig/lua++${LUA_VERSION/.}.pc"
	ln -vsf "lua++${LUA_VERSION/.}.pc" "$TERMUX_PREFIX/lib/pkgconfig/lua++.pc"
	ln -vsf "lua++${LUA_VERSION/.}.pc" "$TERMUX_PREFIX/lib/pkgconfig/lua++${LUA_VERSION}.pc"
	ln -vsf "lua++${LUA_VERSION/.}.pc" "$TERMUX_PREFIX/lib/pkgconfig/lua++-${LUA_VERSION}.pc"
}

termux_step_post_make_install() {
	local LUA_VERSION="${TERMUX_PKG_VERSION%.*}"
	# Rename man pages to lua{,c}${LUA_VERSION}.
	# The general `man 1 lua`/`man 1 luac` are provided
	# via the alternatives system to match
	# the version providing `$TERMUX_PREFIX/bin/lua`
	mv -f \
		"$TERMUX_PREFIX/share/man/man1/lua.1" \
		"$TERMUX_PREFIX/share/man/man1/lua${LUA_VERSION}.1"

	mv -f \
		"$TERMUX_PREFIX/share/man/man1/luac.1" \
		"$TERMUX_PREFIX/share/man/man1/luac${LUA_VERSION}.1"

	export AR="$OLDAR"
}
