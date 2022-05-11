TERMUX_PKG_HOMEPAGE=https://sw.kovidgoyal.net/kitty/
TERMUX_PKG_DESCRIPTION="Cross-platform, fast, feature-rich, GPU based terminal"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.25.0
TERMUX_PKG_SRCURL=https://github.com/kovidgoyal/kitty/releases/download/v${TERMUX_PKG_VERSION}/kitty-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1a2c81bf46687d4141d3182dc984bbc0330791705af152199e5b5815dae933de
TERMUX_PKG_DEPENDS="dbus, fontconfig, freetype, harfbuzz, libpng, librsync, libx11, libxkbcommon, littlecms, mesa (>= 22.0.3), python, zlib"
TERMUX_PKG_BUILD_DEPENDS="libxcursor, libxi, libxinerama, libxrandr, xorgproto"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/kitty/html
"

termux_step_pre_configure() {
	sed 's|@TERMUX_PREFIX@|'"$TERMUX_PREFIX"'|g' \
		$TERMUX_PKG_BUILDER_DIR/posix-shm.c.in > kitty/posix-shm.c

	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	CFLAGS+=" $CPPFLAGS"

	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_make() {
	python setup.py linux-package \
		--ignore-compiler-warnings \
		--verbose
}

termux_step_make_install() {
	cp -rT linux-package $TERMUX_PREFIX
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
