TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="OpenGL demonstration and test programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/demos/mesa-demos-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3046a3d26a7b051af7ebdd257a5f23bfeb160cad6ed952329cdff1e9f1ed496b
TERMUX_PKG_DEPENDS="freeglut, glu, libx11, libxext, opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibdrm=disabled
-Dvulkan=disabled
-Dwayland=disabled
"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	# PatchELF packaged in Ubuntu is too old.
	local PATCHELF_BUILD_SH=$TERMUX_SCRIPTDIR/packages/patchelf/build.sh
	local PATCHELF_SRCURL=$(bash -c ". $PATCHELF_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local PATCHELF_SHA256=$(bash -c ". $PATCHELF_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local PATCHELF_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $PATCHELF_SRCURL)
	termux_download $PATCHELF_SRCURL $PATCHELF_TARFILE $PATCHELF_SHA256
	local PATCHELF_SRCDIR=$TERMUX_PKG_HOSTBUILD_DIR/_patchelf
	mkdir -p $PATCHELF_SRCDIR
	tar xf $PATCHELF_TARFILE -C $PATCHELF_SRCDIR --strip-components=1
	pushd $PATCHELF_SRCDIR
	./bootstrap.sh
	./configure
	make -j $TERMUX_MAKE_PROCESSES
	popd
}

termux_step_pre_configure() {
	rm -f configure
}

termux_step_post_make_install() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/_patchelf/src:$PATH
	local _system_lib=/system/lib
	if [ $TERMUX_ARCH_BITS = 64 ]; then
		_system_lib+=64
	fi
	# As of PatchELF version 0.18.0, the `eglinfo-system` is known to be
	# broken if stripped afterwards. Place the binary under `$PREFIX/opt`
	# to avoid being stripped.
	local _opt_prefix=$TERMUX_PREFIX/opt/eglinfo-system
	local _libdir=${_opt_prefix}/lib
	mkdir -p ${_libdir} ${_opt_prefix}/bin
	ln -sf ${_system_lib}/libEGL.so ${_libdir}/libEGL.so
	ln -sf libEGL.so ${_libdir}/libEGL.so.1
	patchelf --set-rpath ${_libdir} \
		--output ${_opt_prefix}/bin/eglinfo \
		$TERMUX_PREFIX/bin/eglinfo
	ln -sf ${_opt_prefix}/bin/eglinfo $TERMUX_PREFIX/bin/eglinfo-system
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
