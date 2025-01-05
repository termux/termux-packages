TERMUX_PKG_HOMEPAGE=https://www.mingw-w64.org/
TERMUX_PKG_DESCRIPTION="MinGW-w64 runtime for LLVM-MinGW"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@licy183"
# Bump llvm-mingw-w64* to the same version in one PR.
TERMUX_PKG_VERSION="20240417"
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/llvm-mingw/releases/download/$TERMUX_PKG_VERSION/llvm-mingw-$TERMUX_PKG_VERSION-ucrt-ubuntu-20.04-x86_64.tar.xz
TERMUX_PKG_SHA256=d28ce4168c83093adf854485446011a0327bad9fe418014de81beba233ce76f1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/opt/llvm-mingw-w64
	rm -rf $TERMUX_PREFIX/opt/llvm-mingw-w64/{aarch64,armv7,i686,x86_64,generic}-w64-mingw32
	mv $TERMUX_PKG_SRCDIR/{aarch64,armv7,i686,x86_64,generic}-w64-mingw32 $TERMUX_PREFIX/opt/llvm-mingw-w64
}

termux_step_install_license() {
	# Runtimes are consist of runtimes libraries from mingw-w64 and libunwind/libc++ from LLVM
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME

	# Install the license of mingw-w64 and mingw-w64-runtimes
	local _file
	for _file in $TERMUX_PREFIX/opt/llvm-mingw-w64/aarch64-w64-mingw32/share/mingw32/*; do
		cp $_file $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
	done

	# Install the license of LLVM
	cp $TERMUX_PKG_SRCDIR/LICENSE.TXT $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE-LLVM.TXT
}
