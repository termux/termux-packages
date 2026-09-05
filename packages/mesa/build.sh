TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.2.1"
TERMUX_PKG_SRCURL="https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c47e81bddc4760360a41ac3c5acec38acb81f9d750ecef47e7f3adc7021a4442
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libglvnd, libllvm (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION), libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, ncurses, vulkan-loader, zlib, zstd"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BUILD_DEPENDS="libclc, libwayland-cross-scanner, libwayland-protocols, libxrandr, llvm, llvm-tools, mlir, spirv-tools, xorgproto"
TERMUX_PKG_BREAKS="osmesa, osmesa-demos"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b), osmesa"
TERMUX_PKG_REPLACES="libmesa, osmesa"
TERMUX_PKG_HOSTBUILD=true

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
-Dgallium-drivers=llvmpipe,softpipe,virgl,zink
-Dgallium-rusticl=true
-Dglvnd=enabled
-Dxmlconfig=disabled
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	# get the elusive mesa_clc program to run during cross-compilation

	local p="$TERMUX_PKG_BUILDER_DIR/1001-src-compiler-clc-meson.build.diff.beforehostbuild"
	echo "Applying $(basename "${p}")"
	sed \
		-e "s|@LLVM_OPENCL_INCLUDE_DIR@|/usr/lib/llvm-$TERMUX_HOST_LLVM_MAJOR_VERSION/lib/clang/$TERMUX_HOST_LLVM_MAJOR_VERSION/include|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"${p}" | patch --silent -p1 -d "$TERMUX_PKG_SRCDIR"

	local HOST_TRIPLET="$(gcc -dumpmachine)"
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	mkdir -p "${HOSTBUILD_ROOTFS}/usr/share/pkgconfig"
	cp "${TERMUX_PREFIX}/share/pkgconfig/libclc.pc" "${HOSTBUILD_ROOTFS}/usr/share/pkgconfig/"
	PKG_CONFIG_LIBDIR="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/pkgconfig"
	PKG_CONFIG_LIBDIR+=":${HOSTBUILD_ROOTFS}/usr/share/pkgconfig/"
	PKG_CONFIG_LIBDIR+=":$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_LIBDIR
	export PKG_CONFIG_PATH="$PKG_CONFIG_LIBDIR"
	export PATH="${HOSTBUILD_ROOTFS}/usr/bin:${PATH}"

	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP
	termux_setup_rust

	termux_download_ubuntu_packages \
		"libllvmspirvlib-$TERMUX_HOST_LLVM_MAJOR_VERSION-dev" \
		"libllvm$TERMUX_HOST_LLVM_MAJOR_VERSION" \
		"libllvmspirvlib$TERMUX_HOST_LLVM_MAJOR_VERSION.1" \
		"libclang-$TERMUX_HOST_LLVM_MAJOR_VERSION-dev" \
		"libclang-cpp$TERMUX_HOST_LLVM_MAJOR_VERSION-dev" \
		libz3-4 \
		spirv-tools-dev \
		spirv-tools-headers

	local LLVM_CONFIG_ORIG="/usr/bin/llvm-config-$TERMUX_HOST_LLVM_MAJOR_VERSION"
	local LLVM_CONFIG_WRAPPER="${HOSTBUILD_ROOTFS}${LLVM_CONFIG_ORIG}"
	mkdir -p "$(dirname "$LLVM_CONFIG_WRAPPER")"
	cat <<- EOF > "$LLVM_CONFIG_WRAPPER"
		#!/bin/bash
		if [[ "\$1" == "--libdir" ]]; then
			echo "$HOSTBUILD_ROOTFS/usr/lib/llvm-$TERMUX_HOST_LLVM_MAJOR_VERSION/lib"
		elif [[ "\$1" == "--includedir" ]]; then
			echo "$HOSTBUILD_ROOTFS/usr/lib/llvm-$TERMUX_HOST_LLVM_MAJOR_VERSION/include"
		else
			$LLVM_CONFIG_ORIG "\$@"
		fi
	EOF
	chmod +x "$LLVM_CONFIG_WRAPPER"
	export CPPFLAGS="-I$($LLVM_CONFIG_WRAPPER --includedir)"
	CPPFLAGS+=" -I$HOSTBUILD_ROOTFS/usr/lib/llvm-$TERMUX_HOST_LLVM_MAJOR_VERSION/lib/clang/$TERMUX_HOST_LLVM_MAJOR_VERSION/include"
	CPPFLAGS+=" -I$HOSTBUILD_ROOTFS/usr/include"
	export LDFLAGS="-L$HOSTBUILD_ROOTFS/usr/lib/x86_64-linux-gnu"

	cargo install --force --locked bindgen-cli

	(
		. "$TERMUX_SCRIPTDIR/packages/libdrm/build.sh"
		TERMUX_PKG_SRCDIR="$TERMUX_PKG_HOSTBUILD_DIR/libdrm" termux_step_get_source
	)

	$TERMUX_MESON setup \
		libdrm libdrm-build \
		--prefix "$HOSTBUILD_ROOTFS/usr"
	$TERMUX_MESON compile -C libdrm-build
	$TERMUX_MESON install -C libdrm-build

	(
		. "$TERMUX_SCRIPTDIR/packages/libwayland/build.sh"
		TERMUX_PKG_SRCDIR="$TERMUX_PKG_HOSTBUILD_DIR/libwayland" termux_step_get_source
	)

	$TERMUX_MESON setup \
		libwayland libwayland-build \
		-Ddocumentation=false \
		-Ddtd_validation=false \
		-Dtests=false \
		--prefix "$HOSTBUILD_ROOTFS/usr"
	$TERMUX_MESON compile -C libwayland-build
	$TERMUX_MESON install -C libwayland-build

	(
		. "$TERMUX_SCRIPTDIR/packages/libwayland-protocols/build.sh"
		TERMUX_PKG_SRCDIR="$TERMUX_PKG_HOSTBUILD_DIR/libwayland-protocols" termux_step_get_source
	)

	$TERMUX_MESON setup \
		libwayland-protocols libwayland-protocols-build \
		--prefix "$HOSTBUILD_ROOTFS/usr"
	$TERMUX_MESON compile -C libwayland-protocols-build
	$TERMUX_MESON install -C libwayland-protocols-build

	# -Dmesa-clc=enabled and -Dinstall-mesa-clc=true install the mesa_clc program.
	# if the rest of the mesa build is too minimal,
	# link-time symbol errors will occur, so it has to have at least a few things enabled
	$TERMUX_MESON setup \
		"$TERMUX_PKG_SRCDIR" build \
		--prefix "$HOSTBUILD_ROOTFS/usr" \
		-Dinstall-mesa-clc=true \
		-Dmesa-clc=enabled \
		-Dplatforms=wayland \
		-Dllvm=enabled \
		-Dgallium-rusticl=true \
		-Dgallium-drivers=llvmpipe \
		-Dvulkan-drivers=swrast \
		-Dglx=disabled
	$TERMUX_MESON compile -C build
	$TERMUX_MESON install -C build

	# the mesa_clc program is now in ${HOSTBUILD_ROOTFS}/usr/bin
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
	rm "$LLVM_CONFIG_WRAPPER"
}

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -rf subprojects
}

termux_step_pre_configure() {
	# always perform host build so that beforehostbuild diff patch is always applied
	rm -f "$TERMUX_HOSTBUILD_MARKER"

	if [ "$TERMUX_PKG_API_LEVEL" -lt 29 ]; then
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
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dmesa-clc=system"
	fi

	CPPFLAGS+=" -D__USE_GNU"
	LDFLAGS+=" -landroid-shmem"

	# load build tools, including the mesa_clc program built for GNU/Linux
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
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	export PATH="${_WRAPPER_BIN}:${CARGO_HOME}/bin:${HOSTBUILD_ROOTFS}/usr/bin:${PATH}"
	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"

	local _vk_drivers="swrast,virtio"
	if [ $TERMUX_ARCH = "arm" ] || [ $TERMUX_ARCH = "aarch64" ]; then
		_vk_drivers+=",freedreno"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreedreno-kmds=msm,kgsl"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=$_vk_drivers"
}

termux_step_post_configure() {
	rm -f "$_WRAPPER_BIN/cmake"
}

termux_step_post_make_install() {
	# Create symlinks
	ln -sf libEGL_mesa.so "${TERMUX_PREFIX}/lib/libEGL_mesa.so.0"
	ln -sf libGLX_mesa.so "${TERMUX_PREFIX}/lib/libGLX_mesa.so.0"
	ln -sf libRusticlOpenCL.so "${TERMUX_PREFIX}/lib/libRusticlOpenCL.so.1"

	unset BINDGEN_EXTRA_CLANG_ARGS LLVM_CONFIG
}
