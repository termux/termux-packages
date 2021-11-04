TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Integrated Development Environment for Qt"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=4.12.4
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL="https://github.com/qt-creator/qt-creator/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2469a19ee230eb600467e614c23ed678b1b414adc16efdedcfc0404bf40d8015
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtdeclarative, qt5-qtxmlpatterns, qt5-qttools, qt5-qtx11extras, qt5-qtsvg, llvm, clang"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_RECOMMENDS="gdb, git, make, cmake, valgrind"
TERMUX_PKG_SUGGESTS="cvs, subversion"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
    # -r to force Makefile generations for all subdirs at this step so process_stub can be patched
    # Disable QML Designer plugin which requires OpenGL
    # Disable clang refactoring plugin which has odd linking issues at the moment
    export QTC_DO_NOT_BUILD_QMLDESIGNER=1
    export QTC_DISABLE_CLANG_REFACTORING=1
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" -r \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_post_configure() {
    # process_stub's Makefile has the incorrect LINK executable (it should've been QMAKE_CXX)
    sed -i "s|^LINK          = clang|LINK = ${CXX}|" \
        ${TERMUX_PKG_SRCDIR}/src/libs/utils/Makefile.process_stub

    # clangbackend's Makefile lacks -lc++_shared to link against libc++ on x86_64
    sed -i -e 's|^LIBS          = $(SUBLIBS)|LIBS = $(SUBLIBS) -lc++_shared|' \
	-e 's|-Wl,-rpath,/home/builder/.termux-build/_cache/android-r23b-api-24-v1/lib64||g' \
	-e 's|-L/home/builder/.termux-build/_cache/android-r23b-api-24-v1/lib64||g' \
        ${TERMUX_PKG_SRCDIR}/src/tools/clangbackend/Makefile

    # make sure clangtools link against libc++_shared on x86_64
    sed -i -e 's|^LIBS          = $(SUBLIBS)|LIBS = $(SUBLIBS) -lc++_shared|' \
	-e 's|-Wl,-rpath,/home/builder/.termux-build/_cache/android-r23b-api-24-v1/lib64||g' \
	-e 's|-L/home/builder/.termux-build/_cache/android-r23b-api-24-v1/lib64||g' \
        ${TERMUX_PKG_SRCDIR}/src/plugins/clangtools/Makefile

    # required by make install, otherwise it installs to '/'
    export INSTALL_ROOT="${TERMUX_PREFIX}"
}
