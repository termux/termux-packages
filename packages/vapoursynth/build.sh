TERMUX_PKG_HOMEPAGE=https://www.vapoursynth.com/
TERMUX_PKG_DESCRIPTION="Video processing framework with simplicity in mind"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="72"
TERMUX_PKG_SRCURL=https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=650f77feebfd08842b521273f59e0c88f7ba9d7cb5f151d89b79b8dfdd4ce633
TERMUX_PKG_DEPENDS="libzimg, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-x86-asm"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d{2}'

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags https://github.com/vapoursynth/vapoursynth.git \
	| grep -oP "refs/tags/R\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
	| sort -V \
	| tail -n1)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}


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
