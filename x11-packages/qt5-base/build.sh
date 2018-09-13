TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://qt-project.org/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_VERSION=5.11.1
TERMUX_PKG_SRCURL="http://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/$TERMUX_PKG_VERSION/single/qt-everywhere-src-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=39602cb08f9c96867910c375d783eed00fc4a244bffaa93b801225d17950fb2b
TERMUX_PKG_DEPENDS="libsqlite, libjpeg-turbo, libpng, pcre2, openssl, libandroid-support, freetype, harfbuzz, libwebp, fontconfig, libopus, libevent, jsoncpp"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
    sed -e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
        -e "s|@CFLAGS@|$CPPFLAGS $CFLAGS|" \
        -e "s|@CXXFLAGS@|$CPPFLAGS $CXXFLAGS|" \
        -e "s|@LDFLAGS@|$LDFLAGS|" "${TERMUX_PKG_BUILDER_DIR}/mkspec.diff" | patch -p1
}

termux_step_configure () {
    export PKG_CONFIG_SYSROOT_DIR="${TERMUX_PREFIX}"

    "${TERMUX_PKG_SRCDIR}"/configure \
        -prefix "${TERMUX_PREFIX}" \
		-xplatform linux-termux-clang \
		-plugindir "$TERMUX_PREFIX/libexec/Qt" \
        -opensource \
        -confirm-license \
        -debug \
        -no-compile-examples \
        -gui \
        -no-widgets \
        -no-dbus \
        -no-accessibility \
        -no-glib \
        -no-eventfd \
        -no-inotify \
        -no-system-proxies \
        -no-cups \
        -no-opengl \
        -no-vulkan \
        -qpa xcb \
        -no-eglfs \
        -no-gbm \
        -no-kms \
        -no-linuxfb \
        -no-mirclient \
        -xcb \
        -no-libudev \
        -no-evdev \
        -no-libinput \
        -no-mtdev \
        -no-tslib \
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
}
