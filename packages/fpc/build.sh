TERMUX_PKG_HOMEPAGE=https://www.freepascal.org
TERMUX_PKG_DESCRIPTION="The Free Pascal Compiler (Turbo Pascal 7.0 and Delphi compatible)"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="rtl/COPYING.FPC, rtl/COPYING.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/freepascal/files/Source/${TERMUX_PKG_VERSION}/fpcbuild-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
CPU_TARGET=${TERMUX_ARCH}
OS_TARGET=android
BINUTILSPREFIX=${TERMUX_HOST_PLATFORM}
INSTALL_PREFIX=${TERMUX_PREFIX}"

termux_step_pre_configure() {
	termux_setup_fpc

	fpcmake -T "${TERMUX_ARCH}"-android
	patch -p1 < "${TERMUX_PKG_BUILDER_DIR}"/Makefile.diff
}
