TERMUX_PKG_HOMEPAGE=https://luajit.org/
TERMUX_PKG_DESCRIPTION="Just-In-Time Compiler for Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2.1.1761727121" # 2025-10-29T08:38:41Z
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/LuaJIT/LuaJIT.git
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION:2:3}
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libluajit-dev"
TERMUX_PKG_REPLACES="libluajit-dev"
TERMUX_PKG_EXTRA_MAKE_ARGS="amalg PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local current_version="${TERMUX_PKG_VERSION#*:}"
	local response latest_version unix_timestamp_latest
	local api_url='https://archlinux.org/packages/search/json/?name=luajit'
	# Get the latest version from Arch Linux's API.
	# Since this project doesn't do release tags,
	# Repology doesn't return a meaningfully interpretable latest version.
	# We should also identify ourselves via 'User-Agent' as a courtesy.
	response="$(curl -s \
		-H 'User-Agent: Termux update checker 1.0 (github.com/termux/termux-packages)' \
		"${api_url}"
	)"
	latest_version="$(jq -r '.results[0].pkgver' <<< "$response")"
	unix_timestamp_latest="${latest_version##*.}"

	if ! date -d "@${unix_timestamp_latest}" &> /dev/null; then
		local summary
		# shellcheck disable=SC2016
		printf -v summary '%s\n' \
			'### `libluajit`' \
			''\
			"Failed to get latest version of 'luajit'" \
			"from '${api_url}'" \
			''\
			"Timestamp - $(date -d "@${unix_timestamp_latest}" --utc '+%Y-%m-%dT%H:%M:%SZ' 2>&1)" \
			'Prettified `curl` response:' \
			'```json' \
			"$(jq -r <<< "$response")" \
			'```'

		if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
			# If this is the CI, output to the summary file
			echo "$summary" >> "$GITHUB_STEP_SUMMARY"
		else
			# Otherwise output to whatever qualifies as FD2.
			echo "$summary" >&2
		fi
		echo "WARN: Couldn't query new version. Staying at version '${TERMUX_PKG_VERSION}'."
		return 0
	fi

	# If this isn't a dry-run add a human readable (ISO 8601)
	# version of the timestamp as a comment to the version.
	if [[ "${BUILD_PACKAGES}" != "false" && "$current_version" != "$latest_version" ]]; then
		sed \
			-e "s|^\(TERMUX_PKG_VERSION=.*\"\).*|\1 # $(date -d "@${unix_timestamp_latest}" --utc '+%Y-%m-%dT%H:%M:%SZ')|" \
			-i "$TERMUX_PKG_BUILDER_DIR/build.sh"
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

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
	# Note that they end up in the 'luajit' subpackage, not the 'libluajit' one.
	local TERMUX_LUAJIT_DIR="$TERMUX_PREFIX/share/luajit-${LUAJIT_MINOR_VERSION}/jit"
	rm -rf "$TERMUX_LUAJIT_DIR"
	mkdir -p "$TERMUX_LUAJIT_DIR"
	cp "$TERMUX_PKG_SRCDIR"/src/jit/*lua "$TERMUX_LUAJIT_DIR"
}
