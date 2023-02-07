TERMUX_PKG_HOMEPAGE=http://simh.trailing-edge.com/
TERMUX_PKG_DESCRIPTION="A collection of simulators for computer hardware and software from the past"
TERMUX_PKG_LICENSE="MIT, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, slirp/COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=370bfe006d9f9fb87885c31f943d151013cd529f
TERMUX_PKG_VERSION=2022.01.16
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/simh/simh
TERMUX_PKG_SHA256=5a55ff48f69feb8819f46e905803d83586faad0fb3347aa9e91e33b1f0f79c1f
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-posix-semaphore"
TERMUX_PKG_RECOMMENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DONT_USE_ROMS=1 TESTS=0"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi

	cp $TERMUX_PKG_BUILDER_DIR/LICENSE ./
}

termux_step_pre_configure() {
	CFLAGS+=" -fwrapv"
	LDFLAGS+=" -lm -landroid-glob -landroid-posix-semaphore"
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		GCC="$CC" CFLAGS_O="$CFLAGS $CPPFLAGS" LDFLAGS="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_MAKE_ARGS
}

termux_step_make_install() {
	for f in BIN/*; do
		if [ -f "$f" ]; then
			local b="$(basename "$f")"
			install -Dm700 -T "$f" $TERMUX_PREFIX/bin/simh-"$b"
		fi
	done
	local sharedir=$TERMUX_PREFIX/share/simh
	mkdir -p $sharedir
	for f in */*.bin; do
		install -Dm600 -T "$f" $sharedir/"$f"
	done
}
