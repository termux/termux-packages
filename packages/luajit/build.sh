TERMUX_PKG_HOMEPAGE=https://luajit.org/
TERMUX_PKG_DESCRIPTION="Just-In-Time Compiler for Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2.1.1767980792+g707c12b"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/LuaJIT/LuaJIT.git
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION:2:3}
TERMUX_PKG_BREAKS="libluajit-dev, libluajit"
TERMUX_PKG_REPLACES="libluajit-dev, libluajit"
TERMUX_PKG_EXTRA_MAKE_ARGS="amalg PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag

termux_pkg_auto_update() {
	local latest_version current_version="${TERMUX_PKG_VERSION#*:}"
	latest_version="$(
		TERMUX_PKG_SRCURL="https://gitlab.archlinux.org/archlinux/packaging/packages/luajit" \
		termux_gitlab_api_get_tag
	)"

	# Remove the -${rev} from the tag
	latest_version="${latest_version%-*}"

	# Use +g${hash} for the commit portion of the version
	termux_pkg_upgrade_version "${latest_version/+/+g}"
}

termux_step_post_get_source() {
	local expected_commit="${TERMUX_PKG_VERSION##*+g}"
	local expected_timestamp="${TERMUX_PKG_VERSION##*.}"
	expected_timestamp="${expected_timestamp%+g*}"

	# Remember to pull in the necessary amount of git history
	git fetch --shallow-since="$expected_timestamp"

	local actual_commit actual_timestamp
	actual_timestamp="$(git show --no-patch --pretty=format:%at "$expected_commit" --)"
	actual_commit="$(git log --date=unix --before="$expected_timestamp" --after="$expected_timestamp" --pretty=format:"%H")"

	if [[ "${actual_commit::7}" != "${expected_commit::7}" ]]; then
		termux_error_exit <<-EOF

			ERROR: Expected and observed commit at timestamp don't match.
			Expected: '${expected_commit::7}' @$expected_timestamp ($(date -d "@$expected_timestamp" --utc '+%Y-%m-%dT%H:%M:%SZ'))
			Got:      '${actual_commit::7}' @$actual_timestamp ($(date -d "@$actual_timestamp" --utc '+%Y-%m-%dT%H:%M:%SZ'))
		EOF
	fi

	git checkout "$actual_commit"
}

termux_step_pre_configure() {
	# luajit wants same pointer size for host and target build
	export HOST_CC="gcc"
	if (( TERMUX_ARCH_BITS == 32 )); then
		export HOST_CFLAGS="-m32"
		export HOST_LDFLAGS="-m32"
	fi
	export TARGET_FLAGS="$CFLAGS $CPPFLAGS $LDFLAGS"
	export TARGET_SYS=Linux
	unset CFLAGS LDFLAGS
}

termux_step_make_install () {
	local LUAJIT_MINOR_VERSION="${TERMUX_PKG_VERSION:2:3}"

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
	local TERMUX_LUAJIT_DIR="$TERMUX_PREFIX/share/luajit-${LUAJIT_MINOR_VERSION}/jit"
	mkdir -p "$TERMUX_LUAJIT_DIR"
	cp -v "$TERMUX_PKG_SRCDIR"/src/jit/*lua "$TERMUX_LUAJIT_DIR"
}
