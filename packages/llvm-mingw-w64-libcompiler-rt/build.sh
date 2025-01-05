TERMUX_PKG_HOMEPAGE=https://www.llvm.org/
TERMUX_PKG_DESCRIPTION="Compiler runtime libraries for LLVM-MinGW"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@licy183"
# Bump llvm-mingw-w64* to the same version in one PR.
TERMUX_PKG_VERSION="20240417"
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/$TERMUX_PKG_VERSION/llvm-mingw-$TERMUX_PKG_VERSION-ucrt-ubuntu-20.04-x86_64.tar.xz
TERMUX_PKG_SHA256=d28ce4168c83093adf854485446011a0327bad9fe418014de81beba233ce76f1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	# Install compier-rt libraries
	local LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
	rm -rf $TERMUX_PREFIX/lib/clang/$LLVM_MAJOR_VERSION/lib/windows
	mkdir -p $TERMUX_PREFIX/lib/clang/$LLVM_MAJOR_VERSION/lib/windows
	mv $TERMUX_PKG_SRCDIR/lib/clang/$LLVM_MAJOR_VERSION/lib/windows $TERMUX_PREFIX/lib/clang/$LLVM_MAJOR_VERSION/lib/
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp $TERMUX_PKG_SRCDIR/LICENSE.TXT $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}
