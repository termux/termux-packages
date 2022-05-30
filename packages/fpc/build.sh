TERMUX_PKG_HOMEPAGE=https://www.freepascal.org
TERMUX_PKG_DESCRIPTION="The Free Pascal Compiler (Turbo Pascal 7.0 and Delphi compatible)"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="rtl/COPYING.FPC, rtl/COPYING.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/freepascal/files/Source/${TERMUX_PKG_VERSION}/fpc-${TERMUX_PKG_VERSION}.source.tar.gz
TERMUX_PKG_SHA256=d542e349de246843d4f164829953d1f5b864126c5b62fd17c9b45b33e23d2f44
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="CPU_TARGET=${TERMUX_ARCH} OS_TARGET=android"

termux_step_pre_configure() {
	termux_setup_fpc

	fpcmake -T "${TERMUX_ARCH}"-android
}
