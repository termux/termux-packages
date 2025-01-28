TERMUX_PKG_HOMEPAGE=https://chromium.googlesource.com/angle/angle
TERMUX_PKG_DESCRIPTION="A conformant OpenGL ES implementation for Windows, Mac, Linux, iOS and Android"
TERMUX_PKG_LICENSE="BSD 3-Clause, Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT_DATE=2025.01.28
_COMMIT=919853748871efee5723acacedb10da321bf8441
_COMMIT_POSISION=24755
TERMUX_PKG_SRCURL=git+https://chromium.googlesource.com/angle/angle
TERMUX_PKG_VERSION="2.1.$_COMMIT_POSISION-${_COMMIT:0:8}"
TERMUX_PKG_REVISION=1

TERMUX_PKG_HOSTBUILD=true

termux_step_get_source() {
	# Check whether we need to get source
	if [ -f "$TERMUX_PKG_CACHEDIR/.angle-source-fetched" ]; then
		local _fetched_source_version=$(cat $TERMUX_PKG_CACHEDIR/.angle-source-fetched)
		if [ "$_fetched_source_version" = "$TERMUX_PKG_VERSION" ]; then
			echo "[INFO]: Use pre-fetched source (version $_fetched_source_version)."
			ln -sfr $TERMUX_PKG_CACHEDIR/tmp-checkout/angle $TERMUX_PKG_SRCDIR
			return
		fi
	fi

	# Fetch depot_tools
	if [ ! -f "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched" ];then
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $TERMUX_PKG_CACHEDIR/depot_tools
		touch "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/depot_tools:$PATH"
	export DEPOT_TOOLS_UPDATE=0

	# Get source
	rm -rf "$TERMUX_PKG_CACHEDIR/tmp-checkout"
	mkdir -p "$TERMUX_PKG_CACHEDIR/tmp-checkout"
	pushd "$TERMUX_PKG_CACHEDIR/tmp-checkout"
	gclient config --verbose --unmanaged ${TERMUX_PKG_SRCURL#git+}
	echo "" >> .gclient
	echo 'target_os = ["android"]' >> .gclient
	gclient sync --verbose --revision $_COMMIT

	# Check commit posision
	cd angle
	local _real_commit_posision="$(git rev-list HEAD --count)"
	if [ "$_real_commit_posision" != "$_COMMIT_POSISION" ]; then
		termux_error_exit "Please update commit posision. Expected: $_COMMIT_POSISION, current: $_real_commit_posision."
	fi
	popd

	echo "$TERMUX_PKG_VERSION" > "$TERMUX_PKG_CACHEDIR/.angle-source-fetched"
	ln -sfr $TERMUX_PKG_CACHEDIR/tmp-checkout/angle $TERMUX_PKG_SRCDIR
}

termux_step_host_build() {
	cd $TERMUX_PKG_HOSTBUILD_DIR

	termux_setup_ninja
	export PATH="$TERMUX_PKG_CACHEDIR/depot_tools:$PATH"
	export DEPOT_TOOLS_UPDATE=0

	local _target_os=
	if [ "$TERMUX_ARCH" = "aarch64" ] || [ "$TERMUX_ARCH" = "arm" ]; then
		_target_os="arm64"
	elif [ "$TERMUX_ARCH" = "x86_64" ] || [ "$TERMUX_ARCH" = "i686" ]; then
		_target_os="x64"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	# Build with Android's GL
	mkdir -p out/android
	sed -e"s|@TARGET_OS@|$_target_os|g" \
		-e "s|@ENABLE_GL@|true|g" \
		-e "s|@ENABLE_VULKAN@|false|g" \
		-e "s|@USE_VULKAN_NULL@|false|g" \
		-e "s|@TERMUX_PKG_API_LEVEL@|$TERMUX_PKG_API_LEVEL|g" \
		$TERMUX_PKG_BUILDER_DIR/args.gn.in > out/android/args.gn
	pushd $TERMUX_PKG_SRCDIR
	gn gen $TERMUX_PKG_HOSTBUILD_DIR/out/android --export-compile-commands
	popd
	ninja -C out/android
	mkdir -p build/gl
	cp out/android/apks/AngleLibraries.apk build/gl/
	pushd build/gl
	unzip AngleLibraries.apk
	popd

	# Build with Android's Vulkan
	mkdir -p out/android
	sed -e"s|@TARGET_OS@|$_target_os|g" \
		-e "s|@ENABLE_GL@|false|g" \
		-e "s|@ENABLE_VULKAN@|true|g" \
		-e "s|@USE_VULKAN_NULL@|false|g" \
		-e "s|@TERMUX_PKG_API_LEVEL@|$TERMUX_PKG_API_LEVEL|g" \
		$TERMUX_PKG_BUILDER_DIR/args.gn.in > out/android/args.gn
	pushd $TERMUX_PKG_SRCDIR
	gn gen $TERMUX_PKG_HOSTBUILD_DIR/out/android --export-compile-commands
	popd
	ninja -C out/android
	mkdir -p build/vulkan
	cp out/android/apks/AngleLibraries.apk build/vulkan/
	pushd build/vulkan
	unzip AngleLibraries.apk
	popd

	# Build with Android's Vulkan null display
	mkdir -p out/android
	sed -e "s|@TARGET_OS@|$_target_os|g" \
		-e "s|@ENABLE_GL@|false|g" \
		-e "s|@ENABLE_VULKAN@|true|g" \
		-e "s|@USE_VULKAN_NULL@|true|g" \
		-e "s|@TERMUX_PKG_API_LEVEL@|$TERMUX_PKG_API_LEVEL|g" \
		$TERMUX_PKG_BUILDER_DIR/args.gn.in > out/android/args.gn
	pushd $TERMUX_PKG_SRCDIR
	gn gen $TERMUX_PKG_HOSTBUILD_DIR/out/android --export-compile-commands
	popd
	ninja -C out/android
	mkdir -p build/vulkan-null
	cp out/android/apks/AngleLibraries.apk build/vulkan-null/
	pushd build/vulkan-null
	unzip AngleLibraries.apk
	popd
}

termux_step_configure() {
	# Remove this marker all the time, as this package is architecture-specific
	rm -rf $TERMUX_HOSTBUILD_MARKER
}

termux_step_configure() {
	:
}

termux_step_make() {
	:
}

termux_step_make_install() {
	local _lib_dir=
	if [ "$TERMUX_ARCH" = "arm" ]; then
		_lib_dir="armeabi-v7a"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		_lib_dir="x86"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_lib_dir="x86_64"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_lib_dir="arm64-v8a"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	local _type
	for _type in gl vulkan vulkan-null; do
		mkdir -p $TERMUX_PREFIX/opt/angle-android/$_type
		cp -v $TERMUX_PKG_HOSTBUILD_DIR/build/$_type/lib/$_lib_dir/*.so $TERMUX_PREFIX/opt/angle-android/$_type/
	done
}
