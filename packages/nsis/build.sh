TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/nsis/
TERMUX_PKG_DESCRIPTION="A professional open source system to create Windows installers"
# Licenses: zlib/libpng, bzip2, CPL-1.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/nsis/nsis-${TERMUX_PKG_VERSION}-src.tar.bz2
TERMUX_PKG_SHA256=11b54a6307ab46fef505b2700aaf6f62847c25aa6eebaf2ae0aab2f17f0cb297
TERMUX_PKG_AUTO_UPDATE=true
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
