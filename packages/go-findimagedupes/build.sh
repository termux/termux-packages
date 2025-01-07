TERMUX_PKG_HOMEPAGE=https://gitlab.com/opennota/findimagedupes
TERMUX_PKG_DESCRIPTION="Find visually similar or duplicate images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=07fc58e1a09128274170fa21c3ed322b54c29cad
TERMUX_PKG_VERSION=2023.01.29
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=git+https://gitlab.com/opennota/findimagedupes
TERMUX_PKG_SHA256=4454e3d7be0148ef8c1cdfc5b57ad8805802cad15a55f4cbdf327405d0f29537
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="file, libc++, libheif, libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_CONFLICTS="findimagedupes"
TERMUX_PKG_REPLACES="findimagedupes"

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
}

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	export CGO_CFLAGS+=" -I$TERMUX_PREFIX/include/libpng16 -D__GLIBC__"
	export CGO_CXXFLAGS="$CGO_CFLAGS"

	mkdir -p "$GOPATH"/src/gitlab.com/opennota
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/gitlab.com/opennota/findimagedupes

	cd "$GOPATH"/src/gitlab.com/opennota/findimagedupes

	go build .
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/gitlab.com/opennota/findimagedupes/findimagedupes \
		"$TERMUX_PREFIX"/bin/findimagedupes
}
