TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.15.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qtbase-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=05edd00b2a1ba99c85b3fe876fe1c23d63f0a9bbca7df52bc47393cfd8c809c7
TERMUX_PKG_DEPENDS="dbus, double-conversion, harfbuzz, libandroid-shmem, libandroid-sysv-semaphore, libc++, libice, libicu, libjpeg-turbo, libpng, libsm, libuuid (>> 2.38.1), libx11, libxcb, libxi, libxkbcommon, openssl, pcre2, ttf-dejavu, freetype, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm, zlib, glib"
# gtk3 dependency is a run-time dependency only for the gtk platformtheme subpackage
TERMUX_PKG_BUILD_DEPENDS="gtk3"
TERMUX_PKG_SUGGESTS="qt5-qmake"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/fixqt4headers.pl
bin/syncqt.pl
"

# Replacing the old qt5-base packages
TERMUX_PKG_REPLACES="qt5-base"
TERMUX_PKG_BREAKS="qt5-x11extras, qt5-tools, qt5-declarative"

termux_step_pre_configure () {
    if [ "${TERMUX_ARCH}" = "arm" ]; then
        ## -mfpu=neon causes build failure on ARM.
        CFLAGS="${CFLAGS/-mfpu=neon/} -mfpu=vfp"
        CXXFLAGS="${CXXFLAGS/-mfpu=neon/} -mfpu=vfp"
    fi

    ## Create qmake.conf suitable for cross-compiling.
    sed \
        -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
        -e "s|@TERMUX_CC@|${TERMUX_HOST_PLATFORM}-clang|" \
        -e "s|@TERMUX_CXX@|${TERMUX_HOST_PLATFORM}-clang++|" \
        -e "s|@TERMUX_AR@|llvm-ar|" \
        -e "s|@TERMUX_NM@|llvm-nm|" \
        -e "s|@TERMUX_OBJCOPY@|llvm-objcopy|" \
        -e "s|@TERMUX_PKGCONFIG@|${TERMUX_HOST_PLATFORM}-pkg-config|" \
        -e "s|@TERMUX_STRIP@|llvm-strip|" \
        -e "s|@TERMUX_CFLAGS@|${CPPFLAGS} ${CFLAGS}|" \
        -e "s|@TERMUX_CXXFLAGS@|${CPPFLAGS} ${CXXFLAGS}|" \
        -e "s|@TERMUX_LDFLAGS@|${LDFLAGS}|" \
        "${TERMUX_PKG_BUILDER_DIR}/qmake.conf" > "${TERMUX_PKG_SRCDIR}/mkspecs/termux-cross/qmake.conf"
}

termux_step_configure () {
    unset CC CXX LD CFLAGS LDFLAGS PKG_CONFIG_PATH

    "${TERMUX_PKG_SRCDIR}"/configure -v \
        -opensource \
        -confirm-license \
        -release \
        -optimized-tools \
        -xplatform termux-cross \
        -shared \
        -no-rpath \
        -no-use-gold-linker \
        -prefix "${TERMUX_PREFIX}" \
        -docdir "${TERMUX_PREFIX}/share/doc/qt" \
        -archdatadir "${TERMUX_PREFIX}/lib/qt" \
        -datadir "${TERMUX_PREFIX}/share/qt" \
        -plugindir "${TERMUX_PREFIX}/libexec/qt" \
        -hostbindir "${TERMUX_PREFIX}/opt/qt/cross/bin" \
        -hostlibdir "${TERMUX_PREFIX}/opt/qt/cross/lib" \
        -I "${TERMUX_PREFIX}/include" \
        -I "${TERMUX_PREFIX}/include/glib-2.0" \
        -I "${TERMUX_PREFIX}/lib/glib-2.0/include" \
        -I "${TERMUX_PREFIX}/include/gio-unix-2.0" \
        -I "${TERMUX_PREFIX}/include/cairo" \
        -I "${TERMUX_PREFIX}/include/pango-1.0" \
        -I "${TERMUX_PREFIX}/include/fribidi" \
        -I "${TERMUX_PREFIX}/include/harfbuzz" \
        -I "${TERMUX_PREFIX}/include/atk-1.0" \
        -I "${TERMUX_PREFIX}/include/pixman-1" \
        -I "${TERMUX_PREFIX}/include/uuid" \
        -I "${TERMUX_PREFIX}/include/libxml2" \
        -I "${TERMUX_PREFIX}/include/freetype2" \
        -I "${TERMUX_PREFIX}/include/gdk-pixbuf-2.0" \
        -I "${TERMUX_PREFIX}/include/gtk-3.0" \
        -L "${TERMUX_PREFIX}/lib" \
        -nomake examples \
        -no-pch \
        -no-accessibility \
        -glib \
        -gtk \
        -icu \
        -system-doubleconversion \
        -system-pcre \
        -system-zlib \
        -system-freetype \
        -ssl \
        -openssl-linked \
        -no-system-proxies \
        -no-cups \
        -system-harfbuzz \
        -no-opengl \
        -no-vulkan \
        -qpa xcb \
        -no-eglfs \
        -no-gbm \
        -no-kms \
        -no-linuxfb \
        -no-libudev \
        -no-evdev \
        -no-libinput \
        -no-mtdev \
        -no-tslib \
        -xcb \
        -xcb-xlib \
        -gif \
        -system-libpng \
        -system-libjpeg \
        -system-sqlite \
        -sql-sqlite

}

termux_step_post_make_install() {
    #######################################################
    ##
    ##  Compiling necessary libraries for target.
    ##
    #######################################################
    cd "${TERMUX_PKG_SRCDIR}/src/tools/bootstrap" && {
        make clean

        "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
            -spec "${TERMUX_PKG_SRCDIR}/mkspecs/termux-cross" \
            DEFINES+="QT_NO_SYSTEMSEMAPHORE"

        make -j "${TERMUX_MAKE_PROCESSES}"
        install -Dm644 ../../../lib/libQt5Bootstrap.a "${TERMUX_PREFIX}/lib/libQt5Bootstrap.a"
        install -Dm644 ../../../lib/libQt5Bootstrap.prl "${TERMUX_PREFIX}/lib/libQt5Bootstrap.prl"
    }
    cd "${TERMUX_PKG_SRCDIR}/src/tools/bootstrap-dbus" && {
        # create the dbus bootstrap archieve but we don't need to install this
        make clean

        "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
            -spec "${TERMUX_PKG_SRCDIR}/mkspecs/termux-cross"

        make -j "${TERMUX_MAKE_PROCESSES}"
    }

    #######################################################
    ##
    ##  Compiling necessary programs for target.
    ##
    #######################################################
    ## Note: qmake can be built only on host so it is omitted here.
    for i in moc qlalr qvkgen rcc uic qdbuscpp2xml qdbusxml2cpp; do
        cd "${TERMUX_PKG_SRCDIR}/src/tools/${i}" && {
            make clean

            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PKG_SRCDIR}/mkspecs/termux-cross"

            ## Ensure that no '-lpthread' specified in makefile.
            sed \
                -i 's@-lpthread@@g' \
                Makefile

            ## Fix build failure on at least 'i686'.
            sed \
                -i 's@$(LINK) $(LFLAGS) -o $(TARGET) $(OBJECTS) $(OBJCOMP) $(LIBS)@$(LINK) -o $(TARGET) $(OBJECTS) $(OBJCOMP) $(LIBS) $(LFLAGS) -lz@g' \
                Makefile

            make -j "${TERMUX_MAKE_PROCESSES}"
            install -Dm700 "../../../bin/${i}" "${TERMUX_PREFIX}/bin/${i}"
        }
    done
    unset i

    #######################################################
    ##
    ##  Fixes & cleanup.
    ##
    #######################################################

    # Limit the scope, otherwise it'll touch other Qt files in a dirty host env
    for i in Bootstrap Concurrent Core DBus DeviceDiscoverySupport EdidSupport EventDispatcherSupport FbSupport FontDatabaseSupport Gui InputSupport Network PrintSupport ServiceSupport Sql Test ThemeSupport Widget XcbQpa XkbCommonSupport Xml Zlib; do
        ## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
        find "${TERMUX_PREFIX}/lib" -type f -name "libQt5${i}.prl" \
            -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;
    done
    unset i
    sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.prl"

    ## Remove *.la files.
    find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
    find "${TERMUX_PREFIX}/opt/qt/cross/lib" -iname \*.la -delete

    ## Create qmake.conf suitable for compiling host tools (for other modules)
    install -Dm644 \
        "${TERMUX_PKG_BUILDER_DIR}/qplatformdefs.host.h" \
        "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-host/qplatformdefs.h"
    sed \
        -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
        "${TERMUX_PKG_BUILDER_DIR}/qmake.host.conf" > "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-host/qmake.conf"
}

termux_step_create_debscripts() {
    # Some clean-up is happening via `postinst`
    # Because we're using this package in both host (Ubuntu glibc) and device (Termux)
    cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
    sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./postinst
}

