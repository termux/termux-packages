TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.1.2"
TERMUX_PKG_SRCURL="https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=bac2bca9121897a2b8162e79636b50ac998fca799c8e6cf914edd85962babdf0
TERMUX_PKG_BUILD_DEPENDS="libclc, libwayland-protocols, libxrandr, llvm, llvm-tools, mlir, spirv-tools, xorgproto"
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libglvnd, libllvm (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION), libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, ncurses, vulkan-loader, zlib, zstd"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BREAKS="osmesa, osmesa-demos"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b), osmesa"
TERMUX_PKG_REPLACES="libmesa, osmesa"
TERMUX_PKG_AUTO_UPDATE=true

# FIXME: Set `shared-llvm` to disabled if possible
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path $TERMUX_PREFIX
-Dgbm=enabled
-Dopengl=true
-Degl=enabled
-Degl-native-platform=x11
-Dgles1=disabled
-Dgles2=enabled
-Dglx=dri
-Dllvm=enabled
-Dshared-llvm=enabled
-Dplatforms=x11,wayland
-Dgallium-rusticl=true
-Dglvnd=enabled
-Dxmlconfig=disabled
"

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -rf subprojects
}

termux_step_pre_configure() {
	if (( TERMUX_PKG_API_LEVEL < 29 )); then
		# ELF TLS is supported starting with API level 29.
		patch --silent -p1 < "$TERMUX_PKG_BUILDER_DIR/0011-lld-undefined-version.diff"
	fi

	termux_setup_cmake
	termux_setup_rust

	: "${CARGO_HOME:=${HOME}/.cargo}"
	export CARGO_HOME

	cargo install --force --locked bindgen-cli
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
		case "${TERMUX_ARCH}" in
			arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi${TERMUX_PKG_API_LEVEL}" ;;
			*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android${TERMUX_PKG_API_LEVEL}" ;;
		esac
	fi

	CPPFLAGS+=" -D__USE_GNU"
	LDFLAGS+=" -landroid-shmem"

	_WRAPPER_BIN="$TERMUX_PKG_BUILDDIR/_wrapper/bin"
	mkdir -p "$_WRAPPER_BIN"
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		sed 's|@CMAKE@|'"$(command -v cmake)"'|g' \
			"$TERMUX_PKG_BUILDER_DIR/cmake-wrapper.in" \
			> "$_WRAPPER_BIN/cmake"
		chmod 0700 "$_WRAPPER_BIN/cmake"
		termux_setup_wayland_cross_pkg_config_wrapper
	fi
	export LLVM_CONFIG="${TERMUX_PREFIX}/bin/llvm-config"
	export PATH="${_WRAPPER_BIN}:${CARGO_HOME}/bin:${PATH}"

	local _gallium_drivers="llvmpipe,softpipe,virgl,zink"
	local _vk_drivers="swrast"
	case "${TERMUX_ARCH}" in
		aarch64|arm)
			_vk_drivers+=",freedreno"
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreedreno-kmds=msm,kgsl"
		;;
		x86_64)
			# TODO: figure out why these aren't building with LLVM 22.
			# _vk_drivers+=",intel"
		;;
	esac
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dgallium-drivers=$_gallium_drivers"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=$_vk_drivers"
}

termux_step_post_configure() {
	rm -f "$_WRAPPER_BIN/cmake"
}

termux_step_post_make_install() {
	# Create SO symlinks
	ln -sf libEGL_mesa.so "${TERMUX_PREFIX}/lib/libEGL_mesa.so.0"
	ln -sf libGLX_mesa.so "${TERMUX_PREFIX}/lib/libGLX_mesa.so.0"
	ln -sf libRusticlOpenCL.so "${TERMUX_PREFIX}/lib/libRusticlOpenCL.so.1"

	unset BINDGEN_EXTRA_CLANG_ARGS LLVM_CONFIG
}
