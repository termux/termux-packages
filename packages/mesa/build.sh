TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.1.4"
TERMUX_PKG_REVISION=1
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo "${LLVM_MAJOR_VERSION}")
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_PKG_SRCURL=https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=164872a5e792408aa72fecd52b7be6409724c4ad81700798675a7d801d976704
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libglvnd, libllvm (<< ${_LLVM_MAJOR_VERSION_NEXT}), libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, ncurses, vulkan-loader, zlib, zstd"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BUILD_DEPENDS="libclc, libwayland-protocols, libxrandr, llvm, llvm-tools, mlir, spirv-tools, xorgproto"
TERMUX_PKG_BREAKS="osmesa, osmesa-demos"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b), osmesa"
TERMUX_PKG_REPLACES="libmesa, osmesa"

# FIXME: Set `shared-llvm` to disabled if possible
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path $TERMUX_PREFIX
-Dcpp_rtti=false
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
-Dgallium-drivers=llvmpipe,softpipe,virgl,zink
-Dgallium-rusticl=true
-Dglvnd=enabled
-Dxmlconfig=disabled
"

termux_pkg_auto_update() {
	read -r latest < <(curl -fsSL "https://archive.mesa3d.org/" | sed -rn 's/.*mesa-([0-9]+(\.[0-9]+)*).*/\1/p' | sort -Vr);
	termux_pkg_upgrade_version "${latest}"
}

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -rf subprojects
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	: "${CARGO_HOME:=${HOME}/.cargo}"
	export CARGO_HOME

	cargo install --force --locked bindgen-cli
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
		case "${TERMUX_ARCH}" in
		arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/include/c++/v1 -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/arm-linux-androideabi" ;;
		*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/include/c++/v1 -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/${TERMUX_ARCH}-linux-android" ;;
		esac
	fi

	CPPFLAGS+=" -D__USE_GNU"
	LDFLAGS+=" -landroid-shmem"

	_WRAPPER_BIN=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p $_WRAPPER_BIN
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed 's|@CMAKE@|'"$(command -v cmake)"'|g' \
			$TERMUX_PKG_BUILDER_DIR/cmake-wrapper.in \
			> $_WRAPPER_BIN/cmake
		chmod 0700 $_WRAPPER_BIN/cmake
		termux_setup_wayland_cross_pkg_config_wrapper
	fi
	export LLVM_CONFIG="${TERMUX_PREFIX}/bin/llvm-config"
	export PATH="${_WRAPPER_BIN}:${CARGO_HOME}/bin:${PATH}"

	local _vk_drivers="swrast"
	if [ $TERMUX_ARCH = "arm" ] || [ $TERMUX_ARCH = "aarch64" ]; then
		_vk_drivers+=",freedreno"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreedreno-kmds=msm,kgsl"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=$_vk_drivers"
}

termux_step_post_configure() {
	rm -f $_WRAPPER_BIN/cmake
}

termux_step_post_make_install() {
	# Avoid hard links
	local f1
	for f1 in $TERMUX_PREFIX/lib/dri/*; do
		if [ ! -f "${f1}" ]; then
			continue
		fi
		local f2
		for f2 in $TERMUX_PREFIX/lib/dri/*; do
			if [ -f "${f2}" ] && [ "${f1}" != "${f2}" ]; then
				local s1=$(stat -c "%i" "${f1}")
				local s2=$(stat -c "%i" "${f2}")
				if [ "${s1}" = "${s2}" ]; then
					ln -sfr "${f1}" "${f2}"
				fi
			fi
		done
	done

	# Create symlinks
	ln -sf libEGL_mesa.so ${TERMUX_PREFIX}/lib/libEGL_mesa.so.0
	ln -sf libGLX_mesa.so ${TERMUX_PREFIX}/lib/libGLX_mesa.so.0
	ln -sf libRusticlOpenCL.so ${TERMUX_PREFIX}/lib/libRusticlOpenCL.so.1

	unset BINDGEN_EXTRA_CLANG_ARGS LLVM_CONFIG
}
