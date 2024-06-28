TERMUX_PKG_HOMEPAGE=https://github.com/fonttools/skia-pathops
TERMUX_PKG_DESCRIPTION="Python bindings for the Skia library's Path Ops"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION="0.8.0.post1"
TERMUX_PKG_SRCURL=git+$TERMUX_PKG_HOMEPAGE
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_COMMON_DEPS="setuptools, wheel, setuptools_scm, 'Cython>=0.28.4'"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_gn

	local _arch=$TERMUX_ARCH
	if [ "$TERMUX_ARCH" = "i686" ]; then
		_arch="x86"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_arch="x64"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_arch="arm64"
	fi

	sed -e "s|\@NDK_PATH\@|$NDK|g"				\
		-e "s|\@TARGET_CPU\@|$_arch|g"			\
		-e "s|\@GN_PATH\@|$(command -v gn)|g"		\
		$TERMUX_PKG_BUILDER_DIR/build_skia.py.in	\
		> $TERMUX_PKG_SRCDIR/src/cpp/skia-builder/build_skia.py

	export SETUPTOOLS_SCM_PRETEND_VERSION=$TERMUX_PKG_VERSION
	LDFLAGS+=" -llog"
}
