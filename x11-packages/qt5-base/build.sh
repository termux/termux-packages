TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://qt-project.org/
TERMUX_PKG_DESCRIPTION="A cross-platform application and UI framework"
TERMUX_PKG_VERSION=5.11.1
TERMUX_PKG_SRCURL="http://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/$TERMUX_PKG_VERSION/single/qt-everywhere-src-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=39602cb08f9c96867910c375d783eed00fc4a244bffaa93b801225d17950fb2b
#TERMUX_PKG_DEPENDS="libsqlite, libjpeg-turbo, libpng, pcre2, openssl, libandroid-support, freetype, harfbuzz, libwebp, postgresql, mariadb, fontconfig, libopus, libevent, jsoncpp, libprotobuf"
TERMUX_PKG_DEPENDS="libsqlite, libjpeg-turbo, libpng, pcre2, openssl, libandroid-support, freetype, harfbuzz, libwebp, fontconfig, libopus, libevent, jsoncpp"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	#if [ $TERMUX_ARCH_BITS = 32 ]; then
	#	CPPFLAGS+=" -DTERMUX_EXPOSE_FILE_OFFSET64=1"
	#fi
	#LDFLAGS+=" -llog -lpcre2-16 -lpng16 -ljpeg -lsqlite3 -lssl -lfreetype -lharfbuzz -lz -lfontconfig -lwebp -lpq -lmariadb"
	LDFLAGS+=" -llog -lpcre2-16 -lpng16 -ljpeg -lsqlite3 -lssl -lfreetype -lharfbuzz -lz -lfontconfig -lwebp"
	#CPPFLAGS+=" -I$TERMUX_PKG_SRCDIR/include -I$TERMUX_PREFIX/include/freetype2 -I$TERMUX_PREFIX/include/fontconfig -I$TERMUX_PREFIX/include/mysql -I$TERMUX_PKG_BUILDER_DIR"
	CPPFLAGS+=" -I$TERMUX_PKG_SRCDIR/include -I$TERMUX_PREFIX/include/freetype2 -I$TERMUX_PREFIX/include/fontconfig -I$TERMUX_PKG_BUILDER_DIR"
	#CFLAGS+=" $CPPFLAGS"
	#CXXFLAGS+=" $CPPFLAGS"
	sed -e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
		-e "s|@CFLAGS@|$CPPFLAGS $CFLAGS|" \
		-e "s|@CXXFLAGS@|$CPPFLAGS $CXXFLAGS|" \
		-e "s|@LDFLAGS@|$LDFLAGS|" $TERMUX_PKG_BUILDER_DIR/mkspec.diff | patch -p1
}

termux_step_configure () {
    export PKG_CONFIG_SYSROOT_DIR="${TERMUX_PREFIX}"

    $TERMUX_PKG_SRCDIR/configure \
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

    make \
        -j ${TERMUX_MAKE_PROCESSES} \
        -C "${TERMUX_PKG_BUILDDIR}" \
        module-qtbase
}

termux_step_post_massage () {
	# cross compilation only builds tools usable on build machine (i.e. cross tools)
	# manually make tools to be used by the host machine
	for tool in src/tools/{moc,qlalr,uic,rcc} qmake; do
		cd "$TERMUX_PKG_SRCDIR"/qtbase/$tool
		make clean $TERMUX_PKG_EXTRA_MAKE_ARGS
		$TERMUX_PREFIX/bin/qmake
		make -j $TERMUX_MAKE_PROCESSES $TERMUX_PKG_EXTRA_MAKE_ARGS
		#make -j $TERMUX_MAKE_PROCESSES $TERMUX_PKG_EXTRA_MAKE_ARGS CC=$CC CXX=$CXX LINK=$CXX AR="$AR cqs" STRIP=$STRIP \
		#	QMAKESPEC=$TERMUX_PKG_SRCDIR/qtbase/mkspecs/linux-termux-clang \
		#	QMAKE_LFLAGS=$TERMUX_PREFIX/lib/libc++_shared.so \
		#	LIBS="$TERMUX_PREFIX/lib/libc++_shared.so $TERMUX_PKG_BUILDDIR/qtbase/lib/libQt5Core.so $LDFLAGS"
	done

	cp "$TERMUX_PKG_BUILDDIR"/qtbase/bin/{moc,qlalr,uic,rcc,qmake} "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/bin/
}
