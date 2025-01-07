TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="OpenGL demonstration and test programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/demos/mesa-demos-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3046a3d26a7b051af7ebdd257a5f23bfeb160cad6ed952329cdff1e9f1ed496b
TERMUX_PKG_DEPENDS="freeglut, glu, libx11, libxext, opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibdrm=disabled
-Dvulkan=disabled
-Dwayland=disabled
-Dwith-system-data-files=true
"

termux_step_pre_configure() {
	rm -f configure
}

termux_step_post_make_install() {
	local _system_lib=/system/lib
	if [ $TERMUX_ARCH_BITS = 64 ]; then
		_system_lib+=64
	fi
	# Use LD_LIBRARY_PATH for eglinfo-system
	local _opt_prefix=$TERMUX_PREFIX/opt/eglinfo-system
	local _libdir=${_opt_prefix}/lib
	mkdir -p ${_libdir} ${_opt_prefix}/bin
	ln -sf ${_system_lib}/libEGL.so ${_libdir}/libEGL.so
	ln -sf libEGL.so ${_libdir}/libEGL.so.1
	rm -rf ${_opt_prefix}/bin/eglinfo
	cp $TERMUX_PREFIX/bin/eglinfo ${_opt_prefix}/bin/eglinfo
	local _eglinfo_system_script=${_opt_prefix}/bin/eglinfo-system
	rm -rf ${_eglinfo_system_script}
	cat > ${_eglinfo_system_script} <<-EOF
		#!$TERMUX_PREFIX/bin/sh
		export LD_LIBRARY_PATH=${_libdir}
		exec ${_opt_prefix}/bin/eglinfo "\$@"
	EOF
	chmod 0700 ${_eglinfo_system_script}
	ln -sf ${_eglinfo_system_script} $TERMUX_PREFIX/bin/eglinfo-system
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
