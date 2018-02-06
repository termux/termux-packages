TERMUX_PKG_VERSION=5.10.0
TERMUX_PKG_HOMEPAGE=https://www.qt.io
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL="http://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/$TERMUX_PKG_VERSION/single/qt-everywhere-src-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=936d4cf5d577298f4f9fdb220e85b008ae321554a5fcd38072dc327a7296230e
TERMUX_PKG_DEPENDS="libsqlite, libjpeg-turbo, libpng, pcre2, openssl, libandroid-support, freetype, harfbuzz, libwebp, postgresql, mariadb, fontconfig, libopus, libevent, jsoncpp, libprotobuf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS=" -s"

termux_step_pre_configure () {
	#if [ $TERMUX_ARCH_BITS = 32 ]; then
	#	CPPFLAGS+=" -DTERMUX_EXPOSE_FILE_OFFSET64=1"
	#fi
	LDFLAGS+=" -llog -lpcre2-16 -lpng16 -ljpeg -lsqlite3 -lssl -lfreetype -lharfbuzz -lz -lfontconfig -lwebp -lpq -lmariadb"
	CPPFLAGS+=" -I$TERMUX_PKG_SRCDIR/include -I$TERMUX_PREFIX/include/freetype2 -I$TERMUX_PREFIX/include/fontconfig -I$TERMUX_PREFIX/include/mysql -I$TERMUX_PKG_BUILDER_DIR"
	#CFLAGS+=" $CPPFLAGS"
	#CXXFLAGS+=" $CPPFLAGS"
	sed -e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
		-e "s|@CFLAGS@|$CPPFLAGS $CFLAGS|" \
		-e "s|@CXXFLAGS@|$CPPFLAGS $CXXFLAGS|" \
		-e "s|@LDFLAGS@|$LDFLAGS|" $TERMUX_PKG_BUILDER_DIR/mkspec.diff | patch -p1
}

termux_step_configure () {
	export PKG_CONFIG_SYSROOT_DIR="/"

	$TERMUX_PKG_SRCDIR/configure \
		-confirm-license \
		-optimize-size \
		-optimized-tools \
		-opensource \
		-pkg-config \
		-system-sqlite \
		-system-zlib \
		-system-libjpeg \
		-system-libpng \
		-system-pcre \
		-system-freetype \
		-system-harfbuzz \
		-qpa vnc \
		-opengl es2\
		-opengles3 \
		-no-eglfs \
		-syslog \
		-no-assimp \
		-no-cups \
		-no-icu \
		-no-glib \
		-no-dbus \
		-no-fontconfig \
		-force-asserts \
		-system-webp \
		-system-opus \
		-no-pulseaudio \
		-openssl-runtime \
		-nomake examples \
		-prefix $TERMUX_PREFIX \
		-xplatform linux-termux-clang \
		-nomake tests \
		-plugindir "$TERMUX_PREFIX/libexec/Qt"

	make -j $TERMUX_MAKE_PROCESSES -C "$TERMUX_PKG_BUILDDIR" qmake_all || true

	for _makefile in `find "$TERMUX_PKG_BUILDDIR" -type f -name Makefile`; do
		sed -i "s| -lrt||g" "$_makefile"
	done
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
