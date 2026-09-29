TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/llvm-mingw
TERMUX_PKG_DESCRIPTION="MinGW-w64 tools for LLVM-MinGW"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@licy183"
_COMMIT=c4ae0f47b9adf0b6b91dcc906f5b1fbfe342bb42
TERMUX_PKG_VERSION=14.0.0+dev
TERMUX_PKG_SRCURL=git+https://github.com/mingw-w64/mingw-w64
TERMUX_PKG_SHA256=746fed5ddd005dfb4a062eeaa939b71deecdfc6460ba8b55541d354fee7af6c0
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_DEPENDS="llvm-mingw-w64-ucrt"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit <<-EOF
		Checksum mismatch for source files.
		Expected: $TERMUX_PKG_SHA256
		Actual:   ${s% *}
		EOF
	fi
}

termux_step_configure() {
	:
}

termux_step_make() {
	mkdir -p "$TERMUX_PREFIX/opt/llvm-mingw-w64"
	local _INSTALL_PREFIX="$TERMUX_PREFIX/opt/llvm-mingw-w64"
	local _INCLUDE_DIR="$_INSTALL_PREFIX/generic-w64-mingw32/include"

	( # Build gendef
	cd mingw-w64-tools/gendef && mkdir -p build
	cd build && \
	../configure --host="$TERMUX_HOST_PLATFORM" --prefix="$_INSTALL_PREFIX"
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	make install-strip
	mkdir -p "$_INSTALL_PREFIX/share/gendef"
	install -m644 ../COPYING "$_INSTALL_PREFIX/share/gendef"
	)

	( # Build widl
	cd mingw-w64-tools/widl && mkdir -p build
	cd build && \
	../configure --host="$TERMUX_HOST_PLATFORM" \
				--prefix="$_INSTALL_PREFIX" \
				--target=x86_64-w64-mingw32 \
				--with-widl-includedir="$_INCLUDE_DIR"
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	make install-strip
	mkdir -p "$_INSTALL_PREFIX/share/widl"
	install -m644 ../../../COPYING "$_INSTALL_PREFIX/share/widl"
	)

	# The build above produced x86_64-w64-mingw32-widl, add symlinks to it
	# with other prefixes.
	local _arch
	for _arch in aarch64 arm64ec armv7 i686; do
		ln -sf x86_64-w64-mingw32-widl "$_INSTALL_PREFIX/bin/$_arch-w64-mingw32-widl"
	done
	for _arch in aarch64 arm64ec armv7 i686 x86_64; do
		ln -sf x86_64-w64-mingw32-widl "$_INSTALL_PREFIX/bin/$_arch-w64-mingw32uwp-widl"
	done
}

termux_step_make_install() {
	local _INSTALL_PREFIX="$TERMUX_PREFIX/opt/llvm-mingw-w64"
	mkdir -p "$TERMUX_PREFIX/bin"

	# Symlinks tools to $PREFIX/bin
	local _tool
	for _tool in gendef {aarch64,arm64ec,armv7,i686,x86_64}-w64-mingw32{,uwp}-widl; do
		ln -sfr "$_INSTALL_PREFIX/bin/$_tool" "$TERMUX_PREFIX/bin/$_tool"
	done
}

termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"

	cp "$TERMUX_PREFIX/opt/llvm-mingw-w64/share/gendef/COPYING" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-gendef"
	cp "$TERMUX_PREFIX/opt/llvm-mingw-w64/share/widl/COPYING" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-widl"
}
