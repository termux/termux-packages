TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/glvnd/libglvnd
TERMUX_PKG_DESCRIPTION="The GL Vendor-Neutral Dispatch library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v${TERMUX_PKG_VERSION}/libglvnd-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b6e15b06aafb4c0b6e2348124808cbd9b291c647299eaaba2e3202f51ff2f3d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BREAKS="mesa (<< 22.3.3-2)"
TERMUX_PKG_CONFLICTS="libmesa, mesa (<< 22.3.3-2), ndk-sysroot (<= 25b)"
TERMUX_PKG_REPLACES="libmesa, mesa (<< 22.3.3-2)"
TERMUX_PKG_RECOMMENDS="mesa"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtls=false
-Ddispatch-tls=false
"

termux_step_pre_configure() {
	# SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# with system ones (in /system/lib64 or /system/lib):
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_make_install() {
	patch --no-backup-if-mismatch -p1 -d $TERMUX_PREFIX/include \
		< $TERMUX_PKG_BUILDER_DIR/egl-not-android.diff
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}

termux_step_post_massage() {
	# A bunch of programs in the wild assume that the name of OpenGL shared
	# library is `libGL.so.1` and try to dlopen(3) it. In fact `sdl2` does
	# this. Also `libEGL.so` and some others need SOVERSION suffix to avoid
	# conflict with system ones. So let's check if SONAME is properly set.
	local n
	for n in GL EGL GLESv1_CM GLESv2; do
		local f="lib/lib${n}.so"
		if [ ! -e "${f}" ]; then
			termux_error_exit "Shared library ${f} does not exist."
		fi
		if ! readelf -d "${f}" | grep -q '(SONAME).*\[lib'"${n}"'\.so\.'; then
			termux_error_exit "SONAME for ${f} is not properly set."
		fi
	done
}
