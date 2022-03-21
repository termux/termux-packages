TERMUX_PKG_HOMEPAGE=https://gitlab.com/opennota/findimagedupes
TERMUX_PKG_DESCRIPTION="Find visually similar or duplicate images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20190114
TERMUX_PKG_REVISION=11
_COMMIT=237ed2ef4bbb91c79eee0f5ee84a1adad9c014ff
TERMUX_PKG_SRCURL=https://gitlab.com/opennota/findimagedupes/-/archive/${_COMMIT}/findimagedupes-${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=7eb4fbab38c8c1965dafd1d0fddbfac58ba6e1a3d52cd1220df488a0a338abb0
TERMUX_PKG_DEPENDS="file, libc++, libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_CONFLICTS="findimagedupes"
TERMUX_PKG_REPLACES="findimagedupes"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	export CGO_CFLAGS="$CFLAGS $CPPFLAGS -I$TERMUX_PREFIX/include/libpng16 -D__GLIBC__"
	export CGO_CXXFLAGS="$CXXFLAGS $CPPFLAGS -I$TERMUX_PREFIX/include/libpng16 -D__GLIBC__"
	export CGO_LDFLAGS="$LDFLAGS"

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
