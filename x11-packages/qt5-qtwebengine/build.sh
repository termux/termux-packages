TERMUX_PKG_HOMEPAGE=https://github.com/qt/qtwebengine
TERMUX_PKG_DESCRIPTION="Qt 5 Web Engine Library"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-2.0, GPL-3.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.LGPL3, LICENSE.GPL2, LICENSE.GPL3, LICENSE.Chromium"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="5.15.18"
TERMUX_PKG_SRCURL=git+https://github.com/qt/qtwebengine
TERMUX_PKG_GIT_BRANCH=v$TERMUX_PKG_VERSION-lts
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="dbus, fontconfig, libc++, libexpat, libjpeg-turbo, libminizip, libnspr, libnss, libopus, libpng, libsnappy, libvpx, libwebp, libx11, libxkbfile, qt5-qtbase, qt5-qtdeclarative, zlib"
TERMUX_PKG_BUILD_DEPENDS="libdrm, qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	# Generate ffmpeg headers for i686
	mkdir -p fake-bin
	ln -s $(command -v clang-18) fake-bin/clang
	ln -s $(command -v clang++-18) fake-bin/clang++

	# Remove python3 compatibility file preventing using newer python3 versions:
	rm $TERMUX_PKG_SRCDIR/src/3rdparty/chromium/third_party/ffmpeg/chromium/scripts/enum.py

	PATH="$PWD/fake-bin:$PATH" python3 $TERMUX_PKG_SRCDIR/src/3rdparty/chromium/third_party/ffmpeg/chromium/scripts/build_ffmpeg.py --config-only linux noasm-ia32
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_ninja
	termux_setup_nodejs

	# https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=adb049350a5d4b15b5ee19739d9f2baed83f6acf
	export LDFLAGS+=" -Wl,--undefined-version"

	# Remove termux's dummy pkg-config
	local _host_pkg_config="$(cat $(command -v pkg-config) | grep exec | awk '{print $2}')"
	rm -rf $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	mkdir -p $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	ln -s $_host_pkg_config $TERMUX_PKG_TMPDIR/host-pkg-config-bin/pkg-config
	ln -s $(command -v pkg-config) $TERMUX_PKG_TMPDIR/host-pkg-config-bin/$TERMUX_HOST_PLATFORM-pkg-config
	export PATH="$TERMUX_PKG_TMPDIR/host-pkg-config-bin:$PATH"

	# Create dummy sysroot
	rm -rf $TERMUX_PKG_TMPDIR/sysroot
	mkdir -p $TERMUX_PKG_TMPDIR/sysroot
	pushd $TERMUX_PKG_TMPDIR/sysroot
	mkdir -p usr/include usr/lib usr/bin
	cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/* usr/include
	cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$TERMUX_HOST_PLATFORM/* usr/include
	cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/* usr/lib/
	cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_shared.so" usr/lib/
	cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_static.a" usr/lib/
	cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++abi.a" usr/lib/
	cp -Rf $TERMUX_PREFIX/include/* usr/include
	cp -Rf $TERMUX_PREFIX/lib/* usr/lib
	ln -sf /data ./data
	popd

	# Dummy pthread, rt and resolve
	# TODO: Patch the building system and do not dummy `librt.so`.
	echo "INPUT(-llog -liconv -landroid-shmem)" > "$TERMUX_PREFIX/lib/librt.so"
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libpthread.a"
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libresolv.a"

	# Copy ffmpeg headers for i686. They are generated without asm.
	rm -rf src/3rdparty/chromium/third_party/ffmpeg/chromium/config/{Chrome,Chromium}/linux-noasm/ia32
	mkdir -p src/3rdparty/chromium/third_party/ffmpeg/chromium/config/{Chrome,Chromium}/linux-noasm/ia32
	cp -Rfv $TERMUX_PKG_HOSTBUILD_DIR/build.ia32.linux-noasm/Chrome/* src/3rdparty/chromium/third_party/ffmpeg/chromium/config/Chrome/linux-noasm/ia32
	cp -Rfv $TERMUX_PKG_HOSTBUILD_DIR/build.ia32.linux-noasm/Chromium/* src/3rdparty/chromium/third_party/ffmpeg/chromium/config/Chromium/linux-noasm/ia32
	cp -fv src/3rdparty/chromium/third_party/ffmpeg/chromium/config/Chrome/linux-noasm/{x64,ia32}/libavutil/ffversion.h
	cp -fv src/3rdparty/chromium/third_party/ffmpeg/chromium/config/Chromium/linux-noasm/{x64,ia32}/libavutil/ffversion.h

	# Do not run ninja -v, unless NINJAFLAGS is set
	: ${NINJAFLAGS:=" "}
	export NINJAFLAGS

	cd $TERMUX_PKG_BUILDDIR/

	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		$TERMUX_PKG_SRCDIR \
		QT_CONFIG-=no-pkg-config \
		DUMMY_SYSROOT=$TERMUX_PKG_TMPDIR/sysroot \
		PKG_CONFIG_SYSROOT_DIR= \
		PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR \
		PKG_CONFIG_EXECUTABLE=$(command -v pkg-config)
}

termux_step_post_make_install() {
	#######################################################
	##
	##  Fixes & cleanup.
	##
	#######################################################

	## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
	find "${TERMUX_PREFIX}/lib" -type f -name "libQt5WebEngine*.prl" \
		-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

	## Remove *.la files.
	find "${TERMUX_PREFIX}/lib" -iname \*.la -delete

	# Remove dummy files
	rm $TERMUX_PREFIX/lib/lib{{pthread,resolv}.a,rt.so}
}

termux_step_post_massage() {
	# Replace version for cmake
	local _QT_BASE_VERSION=$(. $TERMUX_SCRIPTDIR/x11-packages/qt5-qtbase/build.sh; echo $TERMUX_PKG_VERSION)
	sed -e "s|$TERMUX_PKG_VERSION\ |$_QT_BASE_VERSION |" -i lib/cmake/*/*Config.cmake
}
