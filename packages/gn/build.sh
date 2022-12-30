TERMUX_PKG_HOMEPAGE=https://gn.googlesource.com/gn
TERMUX_PKG_DESCRIPTION="Meta-build system that generates build files for Ninja"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_SRCURL=git+https://gn.googlesource.com/gn
_COMMIT=53ef169800760fdc09f0773bf380fe99eaeab339
_COMMIT_DATE=2022.05.02
TERMUX_PKG_VERSION=${_COMMIT_DATE//./}
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_RECOMMENDS="ninja"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
      	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

}

termux_step_configure() {
	./build/gen.py --no-static-libstdc++
}

termux_step_make() {
	termux_setup_ninja
	ninja -C out/
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin out/gn
}
