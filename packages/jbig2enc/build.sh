TERMUX_PKG_HOMEPAGE=https://github.com/agl/jbig2enc
TERMUX_PKG_DESCRIPTION="An encoder for JBIG2"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ea6a40a2cbf05efb00f3418f2d0ad71232565beb
TERMUX_PKG_VERSION=2019.09.08
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/agl/jbig2enc.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="giflib, leptonica, libc++, libjpeg-turbo, libpng, libtiff, libwebp, python, zlib"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_pre_configure() {
	sh autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
