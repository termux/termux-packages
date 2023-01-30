TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/llvm-mingw
TERMUX_PKG_DESCRIPTION="MinGW-w64 tools for LLVM-MinGW"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=10.0.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ba6b430aed72c63a3768531f6a3ffc2b0fde2c57a3b251450dcf489a894f0894
TERMUX_PKG_BUILD_DEPENDS="llvm-mingw-w64-ucrt"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	:
}

termux_step_make() {
	mkdir -p $TERMUX_PREFIX/opt/llvm-mingw-w64
	local _INSTALL_PREFIX=$TERMUX_PREFIX/opt/llvm-mingw-w64
	local _INCLUDE_DIR="$_INSTALL_PREFIX/generic-w64-mingw32/include"

	# Build gendef
	pushd mingw-w64-tools/gendef
	mkdir -p build && cd build
	../configure --host=$TERMUX_HOST_PLATFORM --prefix="$_INSTALL_PREFIX"
	make -j $TERMUX_MAKE_PROCESSES
	make install-strip
	mkdir -p "$_INSTALL_PREFIX/share/gendef"
	install -m644 ../COPYING "$_INSTALL_PREFIX/share/gendef"
	popd

	# Build widl
	pushd mingw-w64-tools/widl
	mkdir -p build && cd build
	../configure --host=$TERMUX_HOST_PLATFORM \
				--prefix="$_INSTALL_PREFIX" \
				--target=x86_64-w64-mingw32 \
				--with-widl-includedir="$_INCLUDE_DIR" 
	make -j $TERMUX_MAKE_PROCESSES
	make install-strip
	mkdir -p "$_INSTALL_PREFIX/share/widl"
	install -m644 ../../../COPYING "$_INSTALL_PREFIX/share/widl"
	popd

	# The build above produced x86_64-w64-mingw32-widl, add symlinks to it
	# with other prefixes.
	local _arch
	for _arch in aarch64 armv7 i686; do
		ln -sf x86_64-w64-mingw32-widl $_INSTALL_PREFIX/bin/$_arch-w64-mingw32-widl
	done
	for _arch in aarch64 armv7 i686 x86_64; do
		ln -sf x86_64-w64-mingw32-widl $_INSTALL_PREFIX/bin/$_arch-w64-mingw32uwp-widl
	done
}

termux_step_make_install() {
	local _INSTALL_PREFIX=$TERMUX_PREFIX/opt/llvm-mingw-w64
	mkdir -p $TERMUX_PREFIX/bin

	# Symlinks tools to $PREFIX/bin
	local _tool
	for _tool in gendef {aarch64,armv7,i686,x86_64}-w64-mingw32{,uwp}-widl; do
		ln -sr $_INSTALL_PREFIX/bin/$_tool $TERMUX_PREFIX/bin/$_tool
	done
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME

	cp $TERMUX_PREFIX/opt/llvm-mingw-w64/share/gendef/COPYING $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-gendef
	cp $TERMUX_PREFIX/opt/llvm-mingw-w64/share/widl/COPYING $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-widl
}
