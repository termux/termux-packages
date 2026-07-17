TERMUX_PKG_HOMEPAGE=https://luau-lang.org
TERMUX_PKG_DESCRIPTION="A fast, small, safe, gradually typed embeddable scripting language derived from Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.629
TERMUX_PKG_SRCURL=https://github.com/luau-lang/luau/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18b04e673a4e450872b57e1881fc54615f8c18addd8336b3e0b20df43562d50d
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUAU_BUILD_TESTS=OFF
-DLUAU_EXTERN_C=ON
"

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" luau luau-*
	install -Dm600 -t "${TERMUX_PREFIX}/lib/Luau" libLuau.*.a

	declare target=()
	for dir in Analysis Ast CodeGen Common Compiler VM; do
		while read -r header; do
			target+=("$header")
		done < <(find "${TERMUX_PKG_SRCDIR}/$dir/include" -name '*.h')
	done
	install -Dm600 -t "${TERMUX_PREFIX}/include/Luau" "${target[@]}"
}
