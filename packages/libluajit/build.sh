TERMUX_PKG_HOMEPAGE=https://luajit.org/
TERMUX_PKG_DESCRIPTION="Just-In-Time Compiler for Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2.1.1731601260"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/LuaJIT/LuaJIT.git
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION:2:3}
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libluajit-dev"
TERMUX_PKG_REPLACES="libluajit-dev"
TERMUX_PKG_EXTRA_MAKE_ARGS="amalg PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do the same as e.g. Arch linux is doing:
	# The patch version is the timestamp of the above git commit, obtain via `git log`
	local commit_timestamp="${TERMUX_PKG_VERSION:6}"

	# Remember to pull in the necessary amount of git history
	git fetch --shallow-since="$commit_timestamp"

	# Find the commit made at the exact timestamp specified in the version:
	local commit_hash
	commit_hash="$(git log --date=unix --before="$commit_timestamp" --after="$commit_timestamp" --pretty=format:"%H")"
	git checkout "$commit_hash" || termux_error_exit "Couldn't determine git commit for timestamp $commit_timestamp"
}

termux_step_pre_configure() {
	# luajit wants same pointer size for host and target build
	export HOST_CC="gcc"
	if (( TERMUX_ARCH_BITS == 32 )); then
		case "$(uname)" in
			"Linux") # NOTE: "apt install libc6-dev-i386" for 32-bit headers
				export HOST_CFLAGS="-m32"
				export HOST_LDFLAGS="-m32"
			;;
			"Darwin")
				export HOST_CFLAGS="-m32 -arch i386"
				export HOST_LDFLAGS="-arch i386"
			;;
		esac
	fi
	export TARGET_FLAGS="$CFLAGS $CPPFLAGS $LDFLAGS"
	export TARGET_SYS=Linux
	unset CFLAGS LDFLAGS
}

termux_step_make_install () {
	# This is the "minor version" of LuaJIT, e.g 2.1
	# It's also needed by the 'luajit' subpackage so export it.
	export LUAJIT_MINOR_VERSION="${TERMUX_PKG_VERSION:2:3}"

	mkdir -p "$TERMUX_PREFIX/include/luajit-${LUAJIT_MINOR_VERSION}/"
	cp -f "$TERMUX_PKG_SRCDIR"/src/{lauxlib.h,lua.h,lua.hpp,luaconf.h,luajit.h,lualib.h} "$TERMUX_PREFIX/include/luajit-${LUAJIT_MINOR_VERSION}/"
	rm -f "$TERMUX_PREFIX"/lib/libluajit*

	install -Dm600 "$TERMUX_PKG_SRCDIR/src/libluajit.so" "$TERMUX_PREFIX/lib/libluajit-5.1.so.${LUAJIT_MINOR_VERSION}.0"
	install -Dm600 "$TERMUX_PKG_SRCDIR/src/libluajit.a" "$TERMUX_PREFIX/lib/libluajit-5.1.a"
	( # shellcheck disable=SC2164 # We run with `set -eu` so if the cd fails the script exits anyway.
		cd "$TERMUX_PREFIX/lib"
		ln -sf "libluajit-5.1.so.${LUAJIT_MINOR_VERSION}.0" libluajit.so
		ln -sf "libluajit-5.1.so.${LUAJIT_MINOR_VERSION}.0" libluajit-5.1.so
		ln -sf "libluajit-5.1.so.${LUAJIT_MINOR_VERSION}.0" libluajit-5.1.so.2
		ln -sf libluajit-5.1.a libluajit.a
	)

	install -Dm600 "$TERMUX_PKG_SRCDIR/etc/luajit.1" "$TERMUX_PREFIX/share/man/man1/luajit.1"
	install -Dm600 "$TERMUX_PKG_SRCDIR/etc/luajit.pc" "$TERMUX_PREFIX/lib/pkgconfig/luajit.pc"
	install -Dm700 "$TERMUX_PKG_SRCDIR/src/luajit" "$TERMUX_PREFIX/bin/luajit"

	# Files needed for the -b option (http://luajit.org/running.html) to work.
	# Note that they end up in the 'luajit' subpackage, not the 'libluajit' one.
	local TERMUX_LUAJIT_DIR="$TERMUX_PREFIX/share/luajit-${LUAJIT_MINOR_VERSION}/jit"
	rm -rf "$TERMUX_LUAJIT_DIR"
	mkdir -p "$TERMUX_LUAJIT_DIR"
	cp "$TERMUX_PKG_SRCDIR"/src/jit/*lua "$TERMUX_LUAJIT_DIR"
}
