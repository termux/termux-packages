TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="OpenGL demonstration and test programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/demos/mesa-demos-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3046a3d26a7b051af7ebdd257a5f23bfeb160cad6ed952329cdff1e9f1ed496b
TERMUX_PKG_DEPENDS="freeglut, glu, libx11, libxext, opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibdrm=disabled
-Dvulkan=disabled
-Dwayland=disabled
"

termux_step_pre_configure() {
	rm -f configure
}

termux_step_post_make_install() {
	local _system_lib=/system/lib
	if [[ "${TERMUX_ARCH_BITS}" == "64" ]]; then _system_lib+=64; fi
	"$CC" \
		-I"${TERMUX_PKG_SRCDIR}/src/util" \
		-I"${TERMUX_PKG_SRCDIR}/src/glad/include" \
		${CPPFLAGS} ${CFLAGS} \
		-L"${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}" \
		-lEGL \
		-Wl,-rpath="${_system_lib}" \
		${LDFLAGS// -Wl,-rpath=${TERMUX_PREFIX}\/lib} \
		"${TERMUX_PKG_SRCDIR}/src/util/glinfo_common.c" \
		"${TERMUX_PKG_SRCDIR}/src/glad/src/glad.c" \
		"${TERMUX_PKG_SRCDIR}/src/egl/opengl/eglinfo.c" \
		-o "${TERMUX_PREFIX}/bin/eglinfo-system"

	local _eglinfo_system_runpath=$(readelf -dW "${TERMUX_PREFIX}/bin/eglinfo-system" | grep RUNPATH)
	if [ -n "$(echo "${_eglinfo_system_runpath}" | grep "${TERMUX_PREFIX}")" ]; then
		termux_error_exit "eglinfo-system: ${_eglinfo_system_runpath}"
	fi
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
