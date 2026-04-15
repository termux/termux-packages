TERMUX_PKG_HOMEPAGE=https://www.inf.puc-rio.br/~roberto/lpeg
TERMUX_PKG_DESCRIPTION="Pattern-matching library for Lua 5.4"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="1.1.0-2"
TERMUX_PKG_SRCURL="https://luarocks.org/manifests/gvvaughan/lpeg-$TERMUX_PKG_VERSION.src.rock"
TERMUX_PKG_SHA256=836d315b920a5cdd62e21786c6c9fad547c4faa131d5583ebca64f0b6595ee76
TERMUX_PKG_BUILD_DEPENDS="lua51, lua52, lua53, lua54, lua55"
TERMUX_PKG_DEPENDS="lua55"

termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL}")"
	local folder
	set +o pipefail
	folder=$(unzip -qql "$file" | head -n1 | tr -s ' ' | cut -d' ' -f5-)
	rm -Rf "$folder"
	unzip -q "$file"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$TERMUX_PKG_TMPDIR/lpeg-${TERMUX_PKG_VERSION%-*}.tar.gz" -C "$TERMUX_PKG_SRCDIR" --strip-components=1
	set -o pipefail
}

termux_step_pre_configure() {
	declare -ag LUA=('5.1' '5.2' '5.3' '5.4' '5.5')
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
		ln -sf "${TERMUX_PREFIX}/lib/liblpeg-$lua.so" "${TERMUX_PREFIX}/lib/lua/$lua/lpeg.so"
		install -Dm600 lpeg-"${lua//./}"/re.lua "$TERMUX_PREFIX/share/lua/$lua"/re.lua
	done
	# make liblpeg-5.5.so the default one
	ln -sf "${TERMUX_PREFIX}/lib/liblpeg-5.5.so" "${TERMUX_PREFIX}/lib/liblpeg.so"
}
