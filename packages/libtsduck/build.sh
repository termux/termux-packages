TERMUX_PKG_HOMEPAGE=https://tsduck.io/
TERMUX_PKG_DESCRIPTION="An extensible toolkit for MPEG transport streams"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=3.33-3139
TERMUX_PKG_VERSION=${_VERSION//-/.}
TERMUX_PKG_SRCURL=https://github.com/tsduck/tsduck/archive/refs/tags/v${_VERSION}.tar.gz
TERMUX_PKG_SHA256=d7cdad9e46bf454cf7c952f23cd4b18f7690671ee8e0829d3a5da11db94b6201
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libcurl, libedit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
SYSPREFIX=$TERMUX_PREFIX
CROSS_TARGET=$TERMUX_ARCH
CROSS=1
NOTEST=1
NODEKTEC=1
NOHIDES=
NOVATEK=1
NOCURL=
NOPCSC=1
NOSRT=1
NORIST=1
NOEDITLINE=
NOTELETEXT=1
NOGITHUB=1 
"
TERMUX_PKG_RM_AFTER_INSTALL="etc/security etc/udev"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# Needs to call `termux_step_configure_autotools` for `*-config` hack.
	touch configure
	chmod u+x configure
}

termux_step_host_build() {
	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;
	make -j $TERMUX_MAKE_PROCESSES \
		NOTEST=1 \
		NODEKTEC=1 \
		NOHIDES=1 \
		NOVATEK=1 \
		NOCURL=1 \
		NOPCSC=1 \
		NOSRT=1 \
		NORIST=1 \
		NOEDITLINE=1 \
		NOTELETEXT=1 \
		NOGITHUB=1
}

termux_step_pre_configure() {
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/bin/release:$PATH

	CXXFLAGS+=" -fno-strict-aliasing"
	LDFLAGS+=" -landroid-glob"
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		CXX="$CXX" \
		GCC="$CC" \
		LD="$LD" \
		CXXFLAGS_CROSS="$CXXFLAGS $CPPFLAGS" \
		LDFLAGS_CROSS="$LDFLAGS" \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}
