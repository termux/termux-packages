TERMUX_PKG_HOMEPAGE=https://plutolang.github.io/
TERMUX_PKG_DESCRIPTION="Shared library for the Pluto interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @cattokomo"
TERMUX_PKG_VERSION="0.9.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/PlutoLang/Pluto/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a4fae052a9ad47e29a6767047c3e55ab5c887486d14e39248657ff43b45875c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="plutolang (<< 0.9.4-1)"
TERMUX_PKG_REPLACES="plutolang (<< 0.9.4-1)"

termux_step_configure() {
	# can't use php version from termux repo, there's no build for the latest version on the pre-built binaries
	local php_version="8.3.9"
	local tarball_checksum="6c7b45dabc362c9c447c6c9688f8922d0cfa3d5c4618d632c504342d37085e2f"
	
	mkdir -p "${TERMUX_PKG_CACHEDIR}/php"
	termux_download "https://dl.static-php.dev/static-php-cli/common/php-${php_version}-cli-linux-x86_64.tar.gz" \
		"${TERMUX_PKG_CACHEDIR}/php.tar.gz" \
		"${tarball_checksum}"
	tar -zxf "${TERMUX_PKG_CACHEDIR}/php.tar.gz" -C "${TERMUX_PKG_CACHEDIR}/php"
	chmod +x "${TERMUX_PKG_CACHEDIR}/php/php"
	export PATH="${TERMUX_PKG_CACHEDIR}/php:$PATH"
}

termux_step_make() {
	local build linkreadline

	export TARGET_ARCH="${TERMUX_ARCH}"
	CXXFLAGS+=" -DLUA_USE_LINUX -DLUA_USE_READLINE"

	CXXFLAGS="${CPPFLAGS} ${CXXFLAGS}" php scripts/compile.php "${CXX}"
	for build in 'shared' 'static' 'pluto' 'plutoc'; do
		linkreadline=""
		[[ "$build" == "pluto" ]] && linkreadline="-lreadline"
		# ANDROID_ROOT is just a dummy variable, it's required to detect Android platform
		ANDROID_ROOT=/system LDFLAGS="${LDFLAGS} ${linkreadline}" php scripts/link_"$build".php "${CXX}"
	done
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" src/pluto{,c}
	install -Dm644 -t "${TERMUX_PREFIX}/lib" src/libpluto{.so,static.a}
	install -Dm644 -t "${TERMUX_PREFIX}/include/pluto" src/{lua,lauxlib,lualib,luaconf}.h src/lua.hpp
}
