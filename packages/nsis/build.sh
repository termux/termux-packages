TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/nsis/
TERMUX_PKG_DESCRIPTION="A professional open source system to create Windows installers"
# Licenses: zlib/libpng, bzip2, CPL-1.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.08
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/nsis/nsis-${TERMUX_PKG_VERSION}-src.tar.bz2
TERMUX_PKG_SHA256=a85270ad5386182abecb2470e3d7e9bec9fe4efd95210b13551cb386830d1e87
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libiconv, nsis-stubs, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	scons \
		CC="$(command -v $CC)" \
		CXX="$(command -v $CXX)" \
		APPEND_CCFLAGS="$CFLAGS $CPPFLAGS" \
		APPEND_LINKFLAGS="$LDFLAGS" \
		SKIPSTUBS=all \
		SKIPPLUGINS=all \
		SKIPUTILS=all \
		SKIPMISC=all \
		NSIS_CONFIG_CONST_DATA_PATH=no \
		PREFIX="$TERMUX_PREFIX/opt/nsis/nsis" \
		install-compiler
}

termux_step_post_make_install() {
	ln -sfr $TERMUX_PREFIX/opt/nsis/nsis/makensis $TERMUX_PREFIX/bin/

	rm -rf _nsis-stubs
	mkdir -p _nsis-stubs
	pushd _nsis-stubs
	tar xf $TERMUX_PKG_BUILDER_DIR/nsis-stubs.tar.xz --strip-components=1
	install -Dm600 -t $TERMUX_PREFIX/opt/nsis/Stubs *
	popd
}
