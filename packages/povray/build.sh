TERMUX_PKG_HOMEPAGE=https://www.povray.org/
TERMUX_PKG_DESCRIPTION="The Persistence of Vision Raytracer"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
_POVRAY_VERSION_BASE=3.8
TERMUX_PKG_VERSION=${_POVRAY_VERSION_BASE}.0-beta.2
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/POV-Ray/povray/releases/download/v${TERMUX_PKG_VERSION}/povunix-v${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=4717c9bed114deec47cf04a8175cc4060dafc159f26e7896480a60f4411ca5ad
TERMUX_PKG_DEPENDS="boost, libc++, libjpeg-turbo, libpng, libtiff, openexr, povray-data, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/povray-*/html
"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-dependency-tracking
--disable-optimiz
--disable-optimiz-arch
--disable-strip
--enable-io-restrictions
--with-boost=$TERMUX_PREFIX/lib
--with-boost-libdir=$TERMUX_PREFIX/lib
--without-libmkl
--without-libsdl
--without-x
ax_cv_c_compiler_vendor=clang
ax_cv_cxx_compiler_vendor=clang
COMPILED_BY=Termux
"

termux_step_pre_configure() {
	# Fast is justice.
	CFLAGS+=" -Ofast"
	CXXFLAGS+=" -Ofast"
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "povconfuser=\$HOME/.povray/${_POVRAY_VERSION_BASE}" >> postinst
	echo "mkdir -p \$povconfuser/" >> postinst
	echo "for f in povray.conf povray.ini; do" >> postinst
	echo "    if [ ! -f \$povconfuser/\$f ]; then" >> postinst
	echo "        cp \$TERMUX_PREFIX/etc/povray/${_POVRAY_VERSION_BASE}/\$f \$povconfuser/" >> postinst
	echo "    fi" >> postinst
	echo "done" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
