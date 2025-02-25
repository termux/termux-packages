TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.3.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_API_LEVEL=26
_LLVM_MAJOR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)
_LLVM_MAJOR_VERSION_NEXT=$((_LLVM_MAJOR_VERSION + 1))
TERMUX_NO_CLEAN=true
# TERMUX_PKG_SRCURL=https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=git+https://github.com/john-peterson/mesa
TERMUX_PKG_GIT_BRANCH=android
TERMUX_PKG_SRCURL2=(
									 https://android.googlesource.com/platform/frameworks/native
									 https://android.googlesource.com/platform/hardware/libhardware
                   https://android.googlesource.com/platform/system/core
								 )
TERMUX_PKG_GIT_BRANCH2="android-8.0.0_r51"
TERMUX_PKG_SHA256=e641ae27191d387599219694560d221b7feaa91c900bcec46bf444218ed66025
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-shmem, libc++, libdrm, libglvnd, libllvm (<< ${_LLVM_MAJOR_VERSION_NEXT}), libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, ncurses, spirv-llvm-translator, vulkan-loader, zlib, zstd"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, bionic-host, libxrandr, llvm, llvm-tools, mlir, xorgproto"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b)"
TERMUX_PKG_REPLACES="libmesa"

# FIXME: Set `shared-llvm` to disabled if possible
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--reconfigure
--cmake-prefix-path $TERMUX_PREFIX
-Dplatform-sdk-version=$TERMUX_PKG_API_LEVEL
-Dcpp_rtti=false
-Dgbm=enabled
-Dopengl=true
-Degl=enabled
-Degl-native-platform=android
-Dgles1=disabled
-Dgles2=enabled
-Dglx=dri
-Dllvm=enabled
-Dshared-llvm=enabled
-Dplatforms=x11,android
-Dgallium-drivers=panfrost,swrast,virgl,zink
-Dosmesa=true
-Dglvnd=enabled
-Dxmlconfig=disabled
-Dandroid-libbacktrace=disabled
-Dandroid-stub=true
-Dbuild-tests=false
"

termux_step_post_get_source() {
	# /src
	set +e
	cd ../cache
	# Do not use meson wrap projects
	rm -rf subprojects
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL2[@]}-1 ))); do
		git clone --depth 1 --single-branch 	--branch $TERMUX_PKG_GIT_BRANCH2		${TERMUX_PKG_SRCURL2[$i]}
	done
}

termux_step_patch_package() { :; }

termux_step_pre_configure() {
	# /src
	termux_setup_cmake

	cp $TERMUX_PKG_BUILDER_DIR/*.pc .
	sed -i s,@TERMUX_PKG_CACHEDIR@,$TERMUX_PKG_CACHEDIR,g *.pc
	sed -i s,@TERMUX_PREFIX@,$TERMUX_PREFIX,g *.pc

	include=$TERMUX_PKG_CACHEDIR/core/liblog/include:$TERMUX_PKG_CACHEDIR/core/libcutils/include:$TERMUX_PKG_CACHEDIR/core/libsystem/include:$TERMUX_PKG_CACHEDIR/native/vulkan/include:$TERMUX_PKG_CACHEDIR/libs/nativewindow/include
	include2="-I$TERMUX_PKG_CACHEDIR/core/libcutils/include -I$TERMUX_PKG_CACHEDIR/core/libsystem/include -I$TERMUX_PKG_CACHEDIR/native/vulkan/include -I$TERMUX_PKG_CACHEDIR/native/libs/nativewindow/include -I$TERMUX_PKG_CACHEDIR/native/libs/nativewindow/include"
	CPPFLAGS+=" -D__USE_GNU $include2"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --includedir=$include"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS2="-Dc_cpp_args=$include2"
	LDFLAGS+=" -landroid-spawn -landroid-shmem"
	# LDFLAGS+=" -llog -lcutils -lsync -lhardware -lnativewindow -landroid-spawn -landroid-shmem"
	export PKG_CONFIG_PATH=../src
	export C_INCLUDE_PATH=$include
	export LIBRARY_PATH=/lib:/data/data/com.termux/files/usr/opt/bionic-host/lib64/

	_WRAPPER_BIN=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p $_WRAPPER_BIN
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed 's|@CMAKE@|'"$(command -v cmake)"'|g' \
			$TERMUX_PKG_BUILDER_DIR/cmake-wrapper.in \
			> $_WRAPPER_BIN/cmake
		chmod 0700 $_WRAPPER_BIN/cmake
		termux_setup_wayland_cross_pkg_config_wrapper
		export LLVM_CONFIG="$TERMUX_PREFIX/bin/llvm-config"
	fi
	export PATH="$_WRAPPER_BIN:$PATH"

	if [ $TERMUX_ARCH = "arm" ] || [ $TERMUX_ARCH = "aarch64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=swrast,freedreno"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreedreno-kmds=msm,kgsl"
	elif [ $TERMUX_ARCH = "i686" ] || [ $TERMUX_ARCH = "x86_64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvulkan-drivers=swrast"
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi
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
}
