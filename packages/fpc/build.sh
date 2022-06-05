TERMUX_PKG_HOMEPAGE=https://www.freepascal.org
TERMUX_PKG_DESCRIPTION="The Free Pascal Compiler (Turbo Pascal 7.0 and Delphi compatible)"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="rtl/COPYING.FPC, rtl/COPYING.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/freepascal/files/Source/${TERMUX_PKG_VERSION}/fpcbuild-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="OS_TARGET=android NOGDB=1"

termux_step_pre_configure() {
	termux_setup_fpc

	local _ARCH="${TERMUX_ARCH}"
	[[ "${TERMUX_ARCH}" == "i686" ]] && _ARCH=i386

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" CPU_TARGET=${_ARCH}"

	# Setup wrapper bin.
	local _WRAPPER="${TERMUX_PKG_TMPDIR}/wrapper"
	mkdir -p "${_WRAPPER}"

	cat <<- EOF > "${_WRAPPER}/${TERMUX_HOST_PLATFORM}-ld"
		#!$(command -v sh)
		exec ${LD}
	EOF
	cat <<- EOF > "${_WRAPPER}/${TERMUX_HOST_PLATFORM}-ar"
		#!$(command -v sh)
		exec ${AR}
	EOF
	chmod 0700 "${_WRAPPER}/${TERMUX_HOST_PLATFORM}-"{ar,ld}

	export PATH="${_WRAPPER}:/usr/bin:${PATH}"

	# Generate makefile for Android build.
	fpcmake -T "${_ARCH}"-android

	# fpc directly invokes linker, so we need to provode NDK libs dir.
	local libdir && libdir="$(realpath "$("${CC}" --print-file-name libc.so)")"
	sed "s|@LIBDIR@|${TERMUX_PREFIX} ${libdir/\/libc.so/}|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/Makefile.diff | patch -p1
}
