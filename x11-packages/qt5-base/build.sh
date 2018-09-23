TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

##
## TODO:
##
## 1. Enable OpenGL (causes "incomplete type 'QOpenGLContext'").
## 2. Enable feature 'dnslookup' (causes 'static_assert' failure).
## 3. Enable additional libraries as subpackages.
## 4. Use fontconfig (causes failure in configure step).
##

TERMUX_PKG_HOMEPAGE=http://qt-project.org/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_VERSION=5.11.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="http://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/single/qt-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c6104b840b6caee596fa9a35bc5f57f67ed5a99d6a36497b6fe66f990a53ca81
TERMUX_PKG_DEPENDS="harfbuzz, libandroid-support, libandroid-shmem, libc++, libice, libicu, libjpeg-turbo, libpng, libsm, libuuid, libx11, libxcb, libxi, libxkbcommon, openssl, pcre2, ttf-dejavu, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="
bin/moc
bin/qlalr
bin/qvkgen
bin/rcc
bin/uic
bin/qmake
lib/qt/mkspecs
lib/libQt5*.prl
lib/libqt*.prl
"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/fixqt4headers.pl
bin/syncqt.pl
lib/qt/mkspecs/termux-cross
"

termux_step_pre_configure () {
    if [ "${TERMUX_ARCH}" = "arm" ]; then
        ## -mfpu=neon causes build failure on ARM.
        CFLAGS="${CFLAGS/-mfpu=neon/} -mfpu=vfp"
        CXXFLAGS="${CXXFLAGS/-mfpu=neon/} -mfpu=vfp"
    fi

    ## Create qmake.conf suitable for cross-compiling.
    sed \
        -e "s|@TERMUX_CC@|${TERMUX_HOST_PLATFORM}-clang|" \
        -e "s|@TERMUX_CXX@|${TERMUX_HOST_PLATFORM}-clang++|" \
        -e "s|@TERMUX_AR@|${TERMUX_HOST_PLATFORM}-ar|" \
        -e "s|@TERMUX_NM@|${TERMUX_HOST_PLATFORM}-nm|" \
        -e "s|@TERMUX_OBJCOPY@|${TERMUX_HOST_PLATFORM}-objcopy|" \
        -e "s|@TERMUX_PKGCONFIG@|${TERMUX_HOST_PLATFORM}-pkg-config|" \
        -e "s|@TERMUX_STRIP@|${TERMUX_HOST_PLATFORM}-strip|" \
        -e "s|@TERMUX_CFLAGS@|${CPPFLAGS} ${CFLAGS}|" \
        -e "s|@TERMUX_CXXFLAGS@|${CPPFLAGS} ${CXXFLAGS}|" \
        -e "s|@TERMUX_LDFLAGS@|${LDFLAGS}|" \
        "${TERMUX_PKG_BUILDER_DIR}/qmake.conf" > "${TERMUX_PKG_SRCDIR}/qtbase/mkspecs/termux-cross/qmake.conf"
}

termux_step_configure () {
    export PKG_CONFIG_SYSROOT_DIR="${TERMUX_PREFIX}"
    unset CC CXX LD CFLAGS LDFLAGS

    "${TERMUX_PKG_SRCDIR}"/configure -v \
        -opensource \
        -confirm-license \
        -release \
        -xplatform termux-cross \
        -optimized-qmake \
        -no-rpath \
        -no-use-gold-linker \
        -prefix "${TERMUX_PREFIX}" \
        -docdir "${TERMUX_PREFIX}/share/doc/qt" \
        -headerdir "${TERMUX_PREFIX}/include/qt" \
        -archdatadir "${TERMUX_PREFIX}/lib/qt" \
        -datadir "${TERMUX_PREFIX}/share/qt" \
        -sysconfdir "${TERMUX_PREFIX}/etc/xdg" \
        -examplesdir "${TERMUX_PREFIX}/share/doc/qt/examples" \
        -plugindir "$TERMUX_PREFIX/libexec/qt" \
        -nomake examples \
        -skip qt3d \
        -skip qtactiveqt \
        -skip qtandroidextras \
        -skip qtcanvas3d \
        -skip qtcharts \
        -skip qtconnectivity \
        -skip qtdatavis3d \
        -skip qtdeclarative \
        -skip qtdoc \
        -skip qtgamepad \
        -skip qtgraphicaleffects \
        -skip qtimageformats \
        -skip qtlocation \
        -skip qtmacextras \
        -skip qtmultimedia \
        -skip qtnetworkauth \
        -skip qtpurchasing \
        -skip qtquickcontrols \
        -skip qtquickcontrols2 \
        -skip qtremoteobjects \
        -skip qtscript \
        -skip qtscxml \
        -skip qtsensors \
        -skip qtserialbus \
        -skip qtserialport \
        -skip qtspeech \
        -skip qtsvg \
        -skip qttools \
        -skip qttranslations \
        -skip qtvirtualkeyboard \
        -skip qtwayland \
        -skip qtwebchannel \
        -skip qtwebengine \
        -skip qtwebglplugin \
        -skip qtwebsockets \
        -skip qtwebview \
        -skip qtwinextras \
        -skip qtx11extras \
        -skip qtxmlpatterns \
        -no-dbus \
        -no-accessibility \
        -no-glib \
        -no-eventfd \
        -no-inotify \
        -icu \
        -system-pcre \
        -system-zlib \
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
        -no-mirclient \
        -system-xcb \
        -no-libudev \
        -no-evdev \
        -no-libinput \
        -no-mtdev \
        -no-tslib \
        -system-xkbcommon-x11 \
        -no-xkbcommon-evdev \
        -gif \
        -ico \
        -system-libpng \
        -system-libjpeg \
        -sql-sqlite \
        -no-feature-dnslookup
}

termux_step_make() {
    make -j "${TERMUX_MAKE_PROCESSES}"
}

termux_step_make_install() {
    make install

    cd "${TERMUX_PKG_SRCDIR}/qtbase" && {
        ## Save host-compiled Qt dev tools for later
        ## use (e.g. cross-compiling Qt application).
        cp -a bin bin.host
        cd -
    }

    cd "${TERMUX_PKG_SRCDIR}/qtbase/src/tools/bootstrap" && {
        make clean

        "${TERMUX_PKG_SRCDIR}/qtbase/bin/qmake" \
            -spec "${TERMUX_PKG_SRCDIR}/qtbase/mkspecs/termux-cross"

        make -j "${TERMUX_MAKE_PROCESSES}"
    }

    for i in moc qlalr qvkgen rcc uic; do
        cd "${TERMUX_PKG_SRCDIR}/qtbase/src/tools/${i}" && {
            make clean

            "${TERMUX_PKG_SRCDIR}/qtbase/bin/qmake" \
                -spec "${TERMUX_PKG_SRCDIR}/qtbase/mkspecs/termux-cross"

            ## Ensure that no '-lpthread' specified in makefile.
            sed \
                -i 's@-lpthread@@g' \
                "${TERMUX_PKG_SRCDIR}/qtbase/src/tools/${i}/Makefile"

            ## Fix build failure on at least 'i686'.
            sed \
                -i 's@$(LINK) $(LFLAGS) -o $(TARGET) $(OBJECTS) $(OBJCOMP) $(LIBS)@$(LINK) -o $(TARGET) $(OBJECTS) $(OBJCOMP) $(LIBS) $(LFLAGS)@g' \
                Makefile

            make -j "${TERMUX_MAKE_PROCESSES}"

            install \
                -Dm700 "${TERMUX_PKG_BUILDDIR}/qtbase/bin/${i}" \
                "${TERMUX_PREFIX}/bin/${i}"
        }
    done
    unset i

    ## Install target-prebuilt 'qmake' tool.
    cd "${TERMUX_PKG_SRCDIR}" && {
        tar xf "${TERMUX_PKG_BUILDER_DIR}/termux-prebuilt-qmake.txz"
        install \
            -Dm700 "./termux-prebuilt-qmake/bin/termux-${TERMUX_HOST_PLATFORM}-qmake" \
            "${TERMUX_PREFIX}/bin/qmake"
    }

    # Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
    find "${TERMUX_PREFIX}/lib" -type f -name '*.prl' \
        -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;
}

termux_step_create_debscripts() {
    ## FIXME: Qt should be built with fontconfig somehow instead
    ## of using direct path to fonts.
    ## Currently, using post-installation script to create symlink
    ## from /system/bin/fonts to $PREFIX/lib/fonts if possible.
    cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
}

termux_step_post_massage() {
    ## Now install host-compiled Qt dev tools so
    ## it will possible to use them later for other
    ## packages.
    for i in moc qlalr qvkgen rcc uic; do
        install \
            -Dm755 "${TERMUX_PKG_SRCDIR}/qtbase/bin.host/${i}" \
            "${TERMUX_PREFIX}/bin/${i}"
    done
    unset i

    install \
        -Dm755 "${TERMUX_PKG_SRCDIR}/qtbase/qmake/qmake" \
        "${TERMUX_PREFIX}/bin/qmake"
}
