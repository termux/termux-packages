TERMUX_PKG_HOMEPAGE=https://desktop.telegram.org/
TERMUX_PKG_DESCRIPTION="Telegram Desktop Client"
# LICENSE: Modified GPL-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, LEGAL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.3.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/telegramdesktop/tdesktop/releases/download/v$TERMUX_PKG_VERSION/tdesktop-$TERMUX_PKG_VERSION-full.tar.gz"
TERMUX_PKG_SHA256=39b0c93c9d45e9ceb7c56be56402888337b92d4f9980117f510709bfa3bb383d
TERMUX_PKG_DEPENDS="abseil-cpp, boost, ffmpeg, glib, hicolor-icon-theme, hunspell, kf6-kcoreaddons, libandroid-shmem, libc++, libdispatch, libdrm, libjxl, liblz4, libminizip, protobuf, librnnoise, libsigc++-3.0, libx11, libxcomposite, libxdamage, libxrandr, libxtst, openal-soft, opengl, openh264, openssl, pipewire, pulseaudio, qt6-qtbase, qt6-qtimageformats, qt6-qtshadertools, qt6-qtsvg, qt6-qtwayland, xxhash, zlib"
TERMUX_PKG_BUILD_DEPENDS="ada, aosp-libs, boost-headers, glib-cross, qt6-qtbase-cross-tools, qt6-qtshadertools-cross-tools"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true

# The API_KEY and API_HASH is taken from the snap build of telegram-desktop.
# See also:
# https://github.com/telegramdesktop/tdesktop/issues/17435
# https://github.com/telegramdesktop/tdesktop/blob/8fab9167beb2407c1153930ed03a4badd0c2b59f/snap/snapcraft.yaml#L87-L88
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_CXX_SCAN_FOR_MODULES=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_VERBOSE_MAKEFILE=ON
-DDESKTOP_APP_DISABLE_JEMALLOC=ON
-DDESKTOP_APP_DISABLE_AUTOUPDATE=ON
-DDESKTOP_APP_DISABLE_FIDO2=ON
-DTDESKTOP_API_ID=611335
-DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c
-DCRL_FORCE_QT=ON
"

__tdesktop_rust_fetch_source() {
	local _tlottie_archive="$TERMUX_PKG_CACHEDIR/tlottie-92df98dc.tar.gz"
	termux_download \
		"https://github.com/dkaraush/tlottie/archive/92df98dc209bc39b1e567ec74a8c86a0af5239de.tar.gz" \
		"$_tlottie_archive" \
		"7855c45912e59c51fbc530af5e849d6867e52e4d64a0117815add728e5cbee92"
	rm -rf "$TERMUX_PKG_SRCDIR/tlottie"
	mkdir -p "$TERMUX_PKG_SRCDIR/tlottie"
	tar -xf "$_tlottie_archive" --strip-components=1 -C "$TERMUX_PKG_SRCDIR/tlottie"

	local _wallet_engine_archive="$TERMUX_PKG_CACHEDIR/wallet-engine-e59e0d89.tar.gz"
	termux_download \
		"https://github.com/i582/wallet-engine/archive/e59e0d89d7ee90c388bf36e3334c5b276f396697.tar.gz" \
		"$_wallet_engine_archive" \
		"45d22ed481dc4fab07390abfa811c095c424e11c745e87b9d0d27b40efa17da2"
	rm -rf "$TERMUX_PKG_SRCDIR/wallet-engine"
	mkdir -p "$TERMUX_PKG_SRCDIR/wallet-engine"
	tar -xf "$_wallet_engine_archive" --strip-components=1 -C "$TERMUX_PKG_SRCDIR/wallet-engine"

	local _wallet_engine_patch="$TERMUX_PKG_CACHEDIR/wallet-engine-aec47495.patch"
	termux_download \
		"https://raw.githubusercontent.com/desktop-app/patches/aec474953ff7ee9b6e4cd9b8658288ea86d124f3/wallet-engine.patch" \
		"$_wallet_engine_patch" \
		"b40aba82c39a42d0526a85ecfa40d613baa57b1a2d6600e601a42a1576b3b822"
	patch -p1 -d "$TERMUX_PKG_SRCDIR/wallet-engine" -i "$_wallet_engine_patch"
}

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
	__tdesktop_rust_fetch_source
	__tg_owt_fetch_source
	__libtd_fetch_source
}

__cppgir_build() {
	termux_setup_cmake

	pushd $TERMUX_PKG_HOSTBUILD_DIR
	git clone https://github.com/scipy/boost-headers-only
	mkdir -p cppgir-host-build
	pushd cppgir-host-build
	local _extra_args=""
	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		_extra_args+=" -DGIR_DEFAULT_DIRS=$TERMUX_PREFIX/share"
	fi
	cmake \
		-DCMAKE_CXX_FLAGS="-DBOOST_NO_CXX98_FUNCTION_BASE=1" \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR/cppgir-host-build/prefix \
		-DBoost_INCLUDE_DIR=$TERMUX_PKG_HOSTBUILD_DIR/boost-headers-only \
		$_extra_args \
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
	(set +e +u
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

TERMUX_PKG_HOSTBUILD=true
termux_step_host_build() {
	# Compile cppgir
	__cppgir_build
}

__tdesktop_rust_build() {
	termux_setup_rust

	local _rust_dir="$TERMUX_PKG_BUILDDIR/tdesktop_rust"
	local _rust_prefix="$TERMUX_PKG_BUILDDIR/tdesktop_rust-prefix"
	rm -rf "$_rust_dir" "$_rust_prefix"
	mkdir -p "$_rust_dir" "$_rust_prefix"/{lib,include/tlottie,include/wallet_engine}

	pushd "$_rust_dir"
	cargo init --lib --vcs none --name tdesktop_rust .
	printf 'pub use ::tlottie;\npub use ::wallet_engine;\n' > src/lib.rs
	cargo add --path "$TERMUX_PKG_SRCDIR/tlottie" --features c-api
	cargo add --path "$TERMUX_PKG_SRCDIR/wallet-engine"
	cargo rustc --lib --release \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--crate-type staticlib --crate-type cdylib \
		--config "profile.release.opt-level=3" \
		--config "profile.release.lto='off'" \
		--config "profile.release.codegen-units=1" \
		--config "profile.release.panic='unwind'"
	local _rust_target_dir="$_rust_dir/target/$CARGO_TARGET_NAME/release"
	cp "$_rust_target_dir/libtdesktop_rust.a" "$_rust_prefix/lib/"
	cp "$TERMUX_PKG_SRCDIR/tlottie/include/tlottie.h" "$_rust_prefix/include/tlottie/"
	(
		unset CARGO_BUILD_TARGET CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR RANLIB
		cargo run --release \
			--manifest-path "$TERMUX_PKG_SRCDIR/wallet-engine/bindgen/cpp/bindgen/Cargo.toml" \
			--locked -- \
			--library --out-dir "$_rust_prefix/include/wallet_engine" \
			"$_rust_target_dir/libtdesktop_rust.so"
	)
	popd

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDESKTOP_APP_TDESKTOP_RUST_LIBRARY=$_rust_prefix/lib/libtdesktop_rust.a"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDESKTOP_APP_TLOTTIE_INCLUDE_DIR=$_rust_prefix/include/tlottie"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDESKTOP_APP_WALLET_ENGINE_INCLUDE_DIR=$_rust_prefix/include/wallet_engine"
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
-DTG_OWT_BUILD_AUDIO_BACKENDS=OFF
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
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		__libtd_host_build
	fi

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
-DTD_E2E_ONLY=ON
-DTDE2E_INSTALL_INCLUDES=ON
"

	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_CROSSCOMPILING=FALSE"
	fi

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
	__tdesktop_rust_build
	__tg_owt_build
	__libtd_build

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_protobuf
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPREBUILT_CPPGIR=$TERMUX_PKG_HOSTBUILD_DIR/cppgir-host-build/prefix/bin/cppgir"
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		termux_setup_proot

		CPPFLAGS+=" -DG_VA_COPY_AS_ARRAY=0"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPROTOBUF_PROTOC_EXECUTABLE=$(command -v protoc)"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQSB_EXECUTABLE=$TERMUX_PREFIX/opt/qt6/cross/lib/qt6/bin/qsb"

		mkdir -p "$TERMUX_PKG_TMPDIR/bin"
		local _type
		for _type in emoji lang style; do
			cat <<-EOF > $TERMUX_PKG_TMPDIR/bin/codegen_$_type
				#!$(command -v sh)
				exec $(command -v termux-proot-run) $TERMUX_PKG_BUILDDIR/Telegram/codegen/codegen/$_type/codegen_$_type "\$@"
			EOF
			chmod +x $TERMUX_PKG_TMPDIR/bin/codegen_$_type
		done
		local _tool
		for _tool in zxcvbn_dictgen zxcvbn_translit; do
			cat <<-EOF > $TERMUX_PKG_TMPDIR/bin/$_tool
				#!$(command -v sh)
				exec $(command -v termux-proot-run) $TERMUX_PKG_BUILDDIR/Telegram/$_tool "\$@"
			EOF
			chmod +x $TERMUX_PKG_TMPDIR/bin/$_tool
		done
		export PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_CROSSCOMPILING=FALSE"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_AUTOMOC_EXECUTABLE=$TERMUX_PREFIX/lib/qt6/moc"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_AUTORCC_EXECUTABLE=$TERMUX_PREFIX/lib/qt6/rcc"
	fi

	LDFLAGS+=" -landroid-shmem"

	cd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake
}
