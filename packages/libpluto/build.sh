TERMUX_PKG_HOMEPAGE=https://plutolang.github.io/
TERMUX_PKG_DESCRIPTION="Shared library for the Pluto interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION="0.12.1"
TERMUX_PKG_SRCURL="https://github.com/PlutoLang/Pluto/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fd122cb51d87cf00c8b5a02662fa886c42bac52a64513d357d4164f36084eeec
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="dos2unix, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="plutolang (<< 0.9.4-1)"
TERMUX_PKG_REPLACES="plutolang (<< 0.9.4-1)"

termux_step_post_get_source() {
	# robertkirkman: CRLF drives me absolutely up the wall, sorry I can't work with it.
	# if another libpluto maintainer prefers CRLF, please feel free to redo everything I do in CRLF instead.
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		DOS2UNIX="$TERMUX_PKG_TMPDIR/dos2unix"
		(. "$TERMUX_SCRIPTDIR/packages/dos2unix/build.sh"; TERMUX_PKG_SRCDIR="$DOS2UNIX" termux_step_get_source)
		pushd "$DOS2UNIX"
		make dos2unix
		popd # DOS2UNIX
		export PATH="$DOS2UNIX:$PATH"
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 dos2unix
}

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
