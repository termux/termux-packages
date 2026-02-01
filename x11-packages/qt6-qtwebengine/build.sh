TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt 6 WebEngine Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="6.10.2"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtwebengine-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=856eddf292a69a88618567deea67711b4ec720e69bcb575ed7bb539c9023961e
TERMUX_PKG_DEPENDS="dbus, fontconfig, libc++, libexpat, libjpeg-turbo, libminizip, libnspr, libnss, libopus, libpng, libsnappy, libvpx, libwebp, libx11, libxkbfile, pulseaudio, qt6-qtbase (>= ${TERMUX_PKG_VERSION}), qt6-qtdeclarative (>= ${TERMUX_PKG_VERSION}), qt6-qtwebchannel (>= ${TERMUX_PKG_VERSION}), zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
# Qt6-Webengine doesn't support cross-compile for i386.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_MESSAGE_LOG_LEVEL=STATUS
-DCMAKE_SYSTEM_NAME=Linux
-DTEST_glibc=ON
-DQT_GENERATE_SBOM=OFF
-DQT_FEATURE_webengine_system_alsa=OFF
-DQT_FEATURE_webengine_system_pulseaudio=ON
-DQT_FEATURE_webengine_proprietary_codecs=ON
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	mkdir -p host-gn-build
	pushd host-gn-build
	cmake \
		-G Ninja \
		-S ${TERMUX_PKG_SRCDIR}/src/gn \
		-DCMAKE_BUILD_TYPE=MinSizeRel
	ninja -j $TERMUX_PKG_MAKE_PROCESSES
	popd # host-gn-build
}

termux_step_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_nodejs

	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/host-gn-build/MinSizeRel:$PATH"

	# Remove termux's dummy pkg-config
	local _host_pkg_config="$(cat $(command -v pkg-config) | grep exec | awk '{print $2}')"
	rm -rf $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	mkdir -p $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	ln -s $_host_pkg_config $TERMUX_PKG_TMPDIR/host-pkg-config-bin/pkg-config
	ln -s $(command -v pkg-config) $TERMUX_PKG_TMPDIR/host-pkg-config-bin/$TERMUX_HOST_PLATFORM-pkg-config
	export PATH="$TERMUX_PKG_TMPDIR/host-pkg-config-bin:$PATH"

	# Create dummy sysroot
	if [ ! -d "$TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH" ]; then
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
		mv $TERMUX_PKG_TMPDIR/sysroot $TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH
	fi

	# Dummy pthread, rt and resolve
	# TODO: Patch the building system and do not dummy `librt.so`.
	echo "INPUT(-llog -liconv -landroid-shmem)" > "$TERMUX_PREFIX/lib/librt.so"
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libpthread.a"
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libresolv.a"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDUMMY_SYSROOT=$TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH"

	: ${NINJAFLAGS:=""}
	export NINJAFLAGS

	termux_step_configure_cmake
}

termux_step_make_install() {
	cmake \
		--install "${TERMUX_PKG_BUILDDIR}" \
		--prefix "${TERMUX_PREFIX}" \
		--verbose

	# Drop QMAKE_PRL_BUILD_DIR because reference the build dir
	find "${TERMUX_PREFIX}/lib" -type f -name "libQt6Pdf*.prl" \
		-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;
	find "${TERMUX_PREFIX}/lib" -type f -name "libQt6WebEngine*.prl" \
		-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

	# Remove *.la files
	find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}

termux_step_post_make_install() {
	# Remove the dummy files
	rm $TERMUX_PREFIX/lib/lib{{pthread,resolv}.a,rt.so}
}
