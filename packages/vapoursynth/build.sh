TERMUX_PKG_HOMEPAGE=https://www.vapoursynth.com/
TERMUX_PKG_DESCRIPTION="Video processing framework with simplicity in mind"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="73"
TERMUX_PKG_SRCURL="https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1bb8ffe31348eaf46d8f541b138f0136d10edaef0c130c1e5a13aa4a4b057280
TERMUX_PKG_DEPENDS="libzimg, python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="Cython"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-x86-asm"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='R\K\d{2}$'

termux_step_pre_configure() {
	rm -f "$TERMUX_PKG_SRCDIR/setup.py"

	if [[ "$TERMUX_ARCH" == 'aarch64' ]]; then
		export CFLAGS+=" -march=armv8.1-a"
		export CXXFLAGS+=" -march=armv8.1-a"
	fi

	# Workaround borrowed from https://github.com/termux/termux-packages/pull/22212/files
	local _libgcc_file _libgcc_path _libgcc_name
	_libgcc_file="$($CC -print-libgcc-file-name)"
	_libgcc_path="$(dirname "$_libgcc_file")"
	_libgcc_name="$(basename "$_libgcc_file")"

	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/vapoursynth"

	./autogen.sh
}
