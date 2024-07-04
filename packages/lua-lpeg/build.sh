TERMUX_PKG_HOMEPAGE=https://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Pattern-matching library for Lua 5.4"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a
TERMUX_PKG_BUILD_DEPENDS="liblua51, liblua52, liblua53, liblua54"
TERMUX_PKG_DEPENDS="liblua54"

LUA=('5.1' '5.2' '5.3' '5.4')
termux_step_pre_configure() {
	for lua in "${LUA[@]}"; do
		cp -r "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/lpeg-${lua//./}"
	done
}

termux_step_make() {
	for lua in "${LUA[@]}"; do
		cd "${TERMUX_PKG_BUILDDIR}/lpeg-${lua//./}" || :
		make \
			CC="$CC" \
			CFLAGS="$CFLAGS -fPIC -I$TERMUX_PREFIX/include/lua$lua" \
			LDFLAGS="$LDFLAGS -L$TERMUX_PREFIX/lib/lua/$lua -llua$lua" \
			LUADIR="$TERMUX_PREFIX/include/lua/$lua" LUAVER="$lua"
	done
}

termux_step_make_install() {
	sed -Ei 's|"(lp.+\.h)"|"lpeg/\1"|' "${TERMUX_PKG_SRCDIR}"/*.h
	install -Dm600 -t "${TERMUX_PREFIX}/include/lpeg" "${TERMUX_PKG_SRCDIR}"/*.h
	for lua in "${LUA[@]}"; do
		install -Dm600 lpeg-"${lua//./}"/liblpeg.so "$TERMUX_PREFIX/lib/liblpeg-$lua".so
		mkdir -p "${TERMUX_PREFIX}/lib/lua/$lua"
		ln -s "${TERMUX_PREFIX}/lib/liblpeg-$lua.so" "${TERMUX_PREFIX}/lib/lua/$lua/lpeg.so"
		install -Dm600 lpeg-"${lua//./}"/re.lua "$TERMUX_PREFIX/share/lua/$lua"/re.lua
	done
	# make liblpeg-5.4.so the default one
	ln -s "${TERMUX_PREFIX}/lib/liblpeg-5.4.so" "${TERMUX_PREFIX}/lib/liblpeg.so"
}
