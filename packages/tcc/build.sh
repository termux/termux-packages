TERMUX_PKG_HOMEPAGE=https://bellard.org/tcc/
TERMUX_PKG_DESCRIPTION="Tiny C Compiler"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=0f004a0883c640528d69a006706f867d56c809e5
_COMMIT_DATE=20261118
TERMUX_PKG_VERSION=1:0.9.28~p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://repo.or.cz/tinycc.git
TERMUX_PKG_SHA256=3a339ec658d3b84b58f01a579b6cece8f6c4cfcf9ec4431fb701d3b5c14338bb
_UPSTREAM_VERSION="${TERMUX_PKG_VERSION#*:}"
TERMUX_PKG_REPOLOGY_METADATA_VERSION="${_UPSTREAM_VERSION%%~*}"
TERMUX_PKG_DEPENDS="ndk-sysroot"
TERMUX_PKG_GIT_BRANCH=mob
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_get_source() {
	git fetch --unshallow
	git reset --hard $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_configure() {
	:
}

termux_step_make() {
	(
		unset CC CFLAGS LDFLAGS
		./configure --targetos=Termux --cpu="$TERMUX_ARCH" \
			--sysroot="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr" \
			--tcc-switches="-D__ANDROID_MIN_SDK_VERSION__=$TERMUX_PKG_API_LEVEL"
		make -j $TERMUX_PKG_MAKE_PROCESSES tcc libtcc1.a
	)

	./configure --targetos=Termux --cpu="$TERMUX_ARCH" \
		--tcc-switches="-Wl,-rpath=$TERMUX_PREFIX/lib -D__ANDROID_MIN_SDK_VERSION__=$TERMUX_PKG_API_LEVEL"
	make -j $TERMUX_PKG_MAKE_PROCESSES tcc
	make doc
}
