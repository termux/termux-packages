TERMUX_PKG_HOMEPAGE=https://desktop.telegram.org/
TERMUX_PKG_DESCRIPTION="Telegram Desktop Client"
# LICENSE: Modified GPL-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, LEGAL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.14.2
TERMUX_PKG_SRCURL=https://github.com/telegramdesktop/tdesktop/releases/download/v$TERMUX_PKG_VERSION/tdesktop-$TERMUX_PKG_VERSION-full.tar.gz
TERMUX_PKG_SHA256=8a3b2570475584317651c76407176ad884f073b1eacaf07333c9037806279f02
TERMUX_PKG_DEPENDS="abseil-cpp, boost, ffmpeg, glib, hicolor-icon-theme, hunspell, kf6-kcoreaddons, libandroid-shmem, libc++, libdispatch, libdrm, liblz4, libminizip, protobuf, librnnoise, libsigc++-3.0, libx11, libxcomposite, libxdamage, libxrandr, libxtst, openal-soft, opengl, openh264, openssl, pipewire, pulseaudio, qt6-qtbase, qt6-qtimageformats, qt6-qtsvg, xxhash, zlib"
TERMUX_PKG_BUILD_DEPENDS="ada, boost-headers, glib-cross, qt6-qtbase-cross-tools"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true

# The API_KEY and API_HASH is taken from the snap build of telegram-desktop.
# See also:
# https://github.com/telegramdesktop/tdesktop/issues/17435
# https://github.com/telegramdesktop/tdesktop/blob/8fab9167beb2407c1153930ed03a4badd0c2b59f/snap/snapcraft.yaml#L87-L88
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_VERBOSE_MAKEFILE=ON
-DDESKTOP_APP_DISABLE_JEMALLOC=ON
-DDESKTOP_APP_DISABLE_AUTOUPDATE=ON
-DTDESKTOP_API_ID=611335
-DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c
-DLIBTGVOIP_DISABLE_ALSA=ON
-DLIBTGVOIP_DISABLE_PULSEAUDIO=OFF
"

__tg_owt_fetch_source() {
	local _commit=$(TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR bash $TERMUX_PKG_BUILDER_DIR/get_tg_owt_commit.sh)
	if [ ! -d "$TERMUX_PKG_CACHEDIR/tg_owt-$_commit" ]; then
		pushd $TERMUX_PKG_CACHEDIR
		rm -rf tg_owt-tmp
		git init tg_owt-tmp
		pushd tg_owt-tmp
		git remote add origin https://github.com/desktop-app/tg_owt.git
		git fetch --depth=1 origin $_commit
		git reset --hard FETCH_HEAD
		git submodule update --init --recursive --depth=1
		rm -rf .git
		popd # tg_owt
		mv tg_owt-tmp tg_owt-$_commit
		popd # $TERMUX_PKG_CACHEDIR

	fi
	rm -rf $TERMUX_PKG_SRCDIR/tg_owt
	mkdir -p $TERMUX_PKG_SRCDIR/tg_owt
	cp -Rf $TERMUX_PKG_CACHEDIR/tg_owt-$_commit/* $TERMUX_PKG_SRCDIR/tg_owt/
}

__libtd_fetch_source() {
	local _commit=$(TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR bash $TERMUX_PKG_BUILDER_DIR/get_libtd_commit.sh)
	if [ ! -d "$TERMUX_PKG_CACHEDIR/libtd-$_commit" ]; then
		pushd $TERMUX_PKG_CACHEDIR
		rm -rf libtd-tmp
		git init libtd-tmp
		pushd libtd-tmp
		git remote add origin https://github.com/tdlib/td.git
		git fetch --depth=1 origin $_commit
		git reset --hard FETCH_HEAD
		git submodule update --init --recursive --depth=1
		rm -rf .git
		popd # libtd
		mv libtd-tmp libtd-$_commit
		popd # $TERMUX_PKG_CACHEDIR

	fi
	rm -rf $TERMUX_PKG_SRCDIR/libtd
	mkdir -p $TERMUX_PKG_SRCDIR/libtd
	cp -Rf $TERMUX_PKG_CACHEDIR/libtd-$_commit/* $TERMUX_PKG_SRCDIR/libtd/
}

termux_step_post_get_source() {
	__tg_owt_fetch_source
	__libtd_fetch_source

	# Dummy some files to make sure that the usage of code path of Linux rather than Android
	mv Telegram/ThirdParty/libtgvoip/os/android Telegram/ThirdParty/libtgvoip/os/android.unused
	mkdir -p Telegram/ThirdParty/libtgvoip/os/android
	local _file
	for _file in Telegram/ThirdParty/libtgvoip/os/android.unused/*.h; do
		local _name=$(basename $_file)
		echo "#error \"DO NOT INCLUDE THIS FILE\"" > Telegram/ThirdParty/libtgvoip/os/android/"$_name"
	done
}

__cppgir_build() {
	termux_setup_cmake

	pushd $TERMUX_PKG_HOSTBUILD_DIR
	git clone https://github.com/scipy/boost-headers-only
	mkdir -p cppgir-host-build
	pushd cppgir-host-build
	cmake \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR/cppgir-host-build/prefix \
		-DBoost_INCLUDE_DIR=$TERMUX_PKG_HOSTBUILD_DIR/boost-headers-only \
		$TERMUX_PKG_SRCDIR/cmake/external/glib/cppgir
	make -j $TERMUX_PKG_MAKE_PROCESSES cppgir
	make install
	popd # cppgir-host-build
	popd # $TERMUX_PKG_HOSTBUILD_DIR
}

__libtd_host_build() {
	termux_setup_cmake

	mkdir -p $TERMUX_PKG_TMPDIR/host-pkg-config
	ln -sf /usr/bin/pkg-config $TERMUX_PKG_TMPDIR/host-pkg-config/

	pushd $TERMUX_PKG_HOSTBUILD_DIR
	rm -rf libtd-host-build
	mkdir -p libtd-host-build
	pushd libtd-host-build
	(
	export PATH="$TERMUX_PKG_TMPDIR/host-pkg-config:$PATH"
	unset PREFIX prefix CPPFLAGS CC CFLAGS CXX CXXFLAGS LD LDFLAGS PKGCONFIG PKG_CONFIG PKG_CONFIG_DIR PKG_CONFIG_LIBDIR
	cmake \
		-DCMAKE_BUILD_TYPE=Release \
		$TERMUX_PKG_SRCDIR/libtd
	make -j $TERMUX_PKG_MAKE_PROCESSES prepare_cross_compiling
	)
	popd # libtd-host-build
	popd # $TERMUX_PKG_HOSTBUILD_DIR
}

__setup_udocker() {
	pushd $TERMUX_PKG_CACHEDIR
	python3 -m venv udockervenv
	source udockervenv/bin/activate
	pip install udocker
	udocker install
	export UDOCKER_DIR=$TERMUX_PKG_CACHEDIR/udocker
	popd # $TERMUX_PKG_CACHEDIR
}

__tg_codegen_build() {
	__setup_udocker

	pushd $TERMUX_PKG_HOSTBUILD_DIR
	mkdir -p codegen-host-build
	pushd codegen-host-build
	cp -Rf $TERMUX_PKG_SRCDIR/* ./
	udocker pull --platform=linux/amd64 ghcr.io/telegramdesktop/tdesktop/centos_env:latest
	udocker create --name=tg-container --force ghcr.io/telegramdesktop/tdesktop/centos_env:latest
	udocker run \
		--bindhome \
		--workdir=/usr/src/tdesktop/Telegram \
		--volume=$PWD:/usr/src/tdesktop \
		tg-container \
			bash /usr/src/tdesktop/Telegram/configure.sh \
				-DCMAKE_CONFIGURATION_TYPES=Release \
				-DTDESKTOP_API_TEST=ON \
				-DDESKTOP_APP_DISABLE_JEMALLOC=ON
	udocker run \
		--bindhome \
		--workdir=/usr/src/tdesktop/Telegram \
		--volume=$PWD:/usr/src/tdesktop \
		tg-container \
			cmake \
				--build ../out \
				--config Release \
				--target codegen_emoji codegen_lang codegen_style
	udocker rm tg-container
	popd # codegen-host-build
	popd # $TERMUX_PKG_HOSTBUILD_DIR
}

TERMUX_PKG_HOSTBUILD=true
termux_step_host_build() {
	# Compile cppgir
	__cppgir_build

	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		return
	fi

	# Compile codegen
	__tg_codegen_build
}

__tg_owt_build() {
	termux_setup_cmake
	termux_setup_ninja

	local _TG_OWT_BUILD_DIR="$TERMUX_PKG_BUILDDIR"/tg_owt-build
	if [ -f "$_TG_OWT_BUILD_DIR"/.tg_owt-built ]; then
		cd "$_TG_OWT_BUILD_DIR"
		ninja -j $TERMUX_PKG_MAKE_PROCESSES install
		cd "$TERMUX_PKG_BUILDDIR"
		return
	fi

	# Backup vars
	local __old_srcdir="$TERMUX_PKG_SRCDIR"
	local __old_builddir="$TERMUX_PKG_BUILDDIR"
	local __old_conf_args="$TERMUX_PKG_EXTRA_CONFIGURE_ARGS"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR"/tg_owt
	TERMUX_PKG_BUILDDIR="$_TG_OWT_BUILD_DIR"
	# Enabling TG_OWT_USE_PIPEWIRE will pick up `libgbm` which doesn't work on Termux
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_SHARED_LIBS=OFF
-DBUILD_STATIC_LIBS=ON
-DTG_OWT_USE_PIPEWIRE=OFF
"

	# Configure
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake

	# Cross-compile & install
	cd "$TERMUX_PKG_BUILDDIR"
	ninja -j $TERMUX_PKG_MAKE_PROCESSES install

	# Recover vars
	TERMUX_PKG_SRCDIR="$__old_srcdir"
	TERMUX_PKG_BUILDDIR="$__old_builddir"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="$__old_conf_args"

	# Mark as built
	mkdir -p "$_TG_OWT_BUILD_DIR"
	touch -f "$_TG_OWT_BUILD_DIR"/.tg_owt-built
}

__libtd_build() {
	termux_setup_cmake
	termux_setup_ninja

	local _LIBTD_BUILD_DIR="$TERMUX_PKG_BUILDDIR"/libtd-build
	if [ -f "$_LIBTD_BUILD_DIR"/.libtd-built ]; then
		cd "$_LIBTD_BUILD_DIR"
		ninja -j $TERMUX_PKG_MAKE_PROCESSES install
		cd "$TERMUX_PKG_BUILDDIR"
		return
	fi

	# Prepare cross-compiling for libtd
	__libtd_host_build

	# Backup vars
	local __old_srcdir="$TERMUX_PKG_SRCDIR"
	local __old_builddir="$TERMUX_PKG_BUILDDIR"
	local __old_conf_args="$TERMUX_PKG_EXTRA_CONFIGURE_ARGS"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR"/libtd
	TERMUX_PKG_BUILDDIR="$_LIBTD_BUILD_DIR"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_SHARED_LIBS=OFF
-DBUILD_STATIC_LIBS=ON
-DTD_INSTALL_SHARED_LIBRARIES=OFF
-DTD_INSTALL_STATIC_LIBRARIES=ON
"

	# Configure
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake

	# Cross-compile & install
	cd "$TERMUX_PKG_BUILDDIR"
	ninja -j $TERMUX_PKG_MAKE_PROCESSES install

	# Recover vars
	TERMUX_PKG_SRCDIR="$__old_srcdir"
	TERMUX_PKG_BUILDDIR="$__old_builddir"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="$__old_conf_args"

	# Mark as built
	mkdir -p "$_LIBTD_BUILD_DIR"
	touch -f "$_LIBTD_BUILD_DIR"/.libtd-built
}

termux_step_configure() {
	__tg_owt_build
	__libtd_build

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_protobuf
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPREBUILT_CPPGIR=$TERMUX_PKG_HOSTBUILD_DIR/cppgir-host-build/prefix/bin/cppgir"
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		CPPFLAGS+=" -DG_VA_COPY_AS_ARRAY=0"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPROTOBUF_PROTOC_EXECUTABLE=$(command -v protoc)"

		mkdir -p "$TERMUX_PKG_TMPDIR/bin"
		local _type
		for _type in emoji lang style; do
			ln -sf \
				"$TERMUX_PKG_HOSTBUILD_DIR/codegen-host-build/out/Telegram/codegen/codegen/$_type/Release/codegen_$_type" \
				"$TERMUX_PKG_TMPDIR/bin/codegen_$_type"
		done
		cat <<-EOF > $TERMUX_PKG_TMPDIR/bin/clang-scan-deps
			#!$(command -v sh)
			exec $TERMUX_STANDALONE_TOOLCHAIN/bin/clang-scan-deps "\$@" --sysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot
		EOF
		chmod +x $TERMUX_PKG_TMPDIR/bin/clang-scan-deps
		export PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_CXX_COMPILER_CLANG_SCAN_DEPS=$TERMUX_PKG_TMPDIR/bin/clang-scan-deps"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_CROSSCOMPILING=FALSE"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_AUTOMOC_EXECUTABLE=$TERMUX_PREFIX/lib/qt6/moc"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_AUTORCC_EXECUTABLE=$TERMUX_PREFIX/lib/qt6/rcc"
	fi

	LDFLAGS+=" -landroid-shmem"

	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake
}
