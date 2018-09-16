TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://qt-project.org/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_VERSION=5.11.1
TERMUX_PKG_SRCURL="http://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/$TERMUX_PKG_VERSION/single/qt-everywhere-src-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=39602cb08f9c96867910c375d783eed00fc4a244bffaa93b801225d17950fb2b
TERMUX_PKG_DEPENDS="harfbuzz, libandroid-support, libandroid-shmem, libc++, libice, libicu, libjpeg-turbo, libpng, libsm, libxcb, libxkbcommon, openssl, pcre2, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
    sed -e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
        -e "s|@CFLAGS@|$CPPFLAGS $CFLAGS|" \
        -e "s|@CXXFLAGS@|$CPPFLAGS $CXXFLAGS|" \
        -e "s|@LDFLAGS@|$LDFLAGS|" "${TERMUX_PKG_BUILDER_DIR}/mkspec.diff" | patch -p1
}

termux_step_configure () {
    export PKG_CONFIG_SYSROOT_DIR="${TERMUX_PREFIX}"

    "${TERMUX_PKG_SRCDIR}"/configure -v \
        -prefix "${TERMUX_PREFIX}" \
        -docdir "${TERMUX_PREFIX}/share/doc/qt" \
        -headerdir "${TERMUX_PREFIX}/include/qt" \
        -archdatadir "${TERMUX_PREFIX}/lib/qt" \
        -datadir "${TERMUX_PREFIX}/share/qt" \
        -sysconfdir "${TERMUX_PREFIX}/etc/xdg" \
        -examplesdir "${TERMUX_PREFIX}/share/doc/qt/examples" \
        -xplatform "linux-termux-clang" \
        -plugindir "$TERMUX_PREFIX/libexec/qt" \
        -opensource \
        -confirm-license \
        -no-rpath \
        -optimized-qmake \
        -nomake examples \
        -gui \
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
        -no-pulseaudio \
        -no-alsa \
        -no-gstreamer \
        -no-webengine-alsa \
        -no-webengine-pulseaudio \
        -no-webengine-embedded-build \
        -no-feature-dnslookup
}

termux_step_make() {
    make -j "${TERMUX_MAKE_PROCESSES}" module-qtbase
}

termux_step_make_install() {
    make -C qtbase install

    cd "${TERMUX_PKG_SRCDIR}/qtbase/src/tools/bootstrap" && {
        make clean

        "${TERMUX_PKG_SRCDIR}/qtbase/bin/qmake" \
            -spec "${TERMUX_PKG_SRCDIR}/qtbase/mkspecs/linux-termux-clang"

        make -j "${TERMUX_MAKE_PROCESSES}"
    }

    for i in moc qlalr qvkgen rcc uic; do
        cd "${TERMUX_PKG_SRCDIR}/qtbase/src/tools/${i}" && {
            make clean

            "${TERMUX_PKG_SRCDIR}/qtbase/bin/qmake" \
                -spec "${TERMUX_PKG_SRCDIR}/qtbase/mkspecs/linux-termux-clang"

            sed \
                -i 's@-lpthread@@g' \
                "${TERMUX_PKG_SRCDIR}/qtbase/src/tools/${i}/Makefile"

            make -j "${TERMUX_MAKE_PROCESSES}"

            install \
                -Dm700 "${TERMUX_PKG_BUILDDIR}/qtbase/bin/${i}" \
                "${TERMUX_PREFIX}/bin/${i}"
        }
    done
    unset i

    cd "${TERMUX_PKG_SRCDIR}/qtbase/qmake" && {
        make clean

        make \
            -j "${TERMUX_MAKE_PROCESSES}" \
            AR="${AR} cqs" \
            CC="${CC}" \
            CXX="${CXX}" \
            LINK="${CXX}" \
            STRIP="${STRIP}" \
            QMAKESPEC="${TERMUX_PKG_SRCDIR}/qtbase/mkspecs/linux-termux-clang" \
            QMAKE_LFLAGS="${TERMUX_PREFIX}/lib/libc++_shared.so"

        install \
            -Dm700 "${TERMUX_PKG_BUILDDIR}/qtbase/bin/qmake" \
            "${TERMUX_PREFIX}/bin/qmake"
    }
}
