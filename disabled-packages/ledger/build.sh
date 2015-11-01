# This package depends on boost, which is not yet available:
# https://github.com/ledger/ledger#user-content-dependencies
TERMUX_PKG_HOMEPAGE=http://ledger-cli.org/
TERMUX_PKG_DESCRIPTION="Powerful, double-entry accounting system"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_SRCURL=https://github.com/ledger/ledger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME="ledger-${TERMUX_PKG_VERSION}"
# TERMUX_PKG_DEPENDS="..."

termux_step_configure () {
	cd $TERMUX_PKG_BUILDDIR
	cmake -G "Unix Makefiles" .. \
		-DCMAKE_AR=`which ${TERMUX_HOST_PLATFORM}-ar` \
                -DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_LINKER=`which ${TERMUX_HOST_PLATFORM}-ld` \
                -DCMAKE_MAKE_PROGRAM=`which make` \
		-DCMAKE_RANLIB=`which ${TERMUX_HOST_PLATFORM}-ranlib` \
                -DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DCMAKE_SYSTEM_NAME=Linux \
                -DCMAKE_USE_SYSTEM_LIBRARIES=True \
                -DBUILD_TESTING=OFF \
		$TERMUX_PKG_SRCDIR
}
