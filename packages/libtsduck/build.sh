TERMUX_PKG_HOMEPAGE=https://tsduck.io/
TERMUX_PKG_DESCRIPTION="An extensible toolkit for MPEG transport streams"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.39.3956"
_VERSION=$(echo "${TERMUX_PKG_VERSION}" | sed 's/\./-/2')
TERMUX_PKG_SRCURL=https://github.com/tsduck/tsduck/archive/refs/tags/v${_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a391504967bd7a6ffb1cabd98bc6ee904a742081c0a17ead4d6639d58c82979
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libcurl, libedit"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/-/./g'
TERMUX_PKG_EXTRA_MAKE_ARGS="
ALTDEVROOT=${TERMUX_PREFIX}
CROSS=1
CROSS_TARGET=${TERMUX_ARCH}
NOCURL=
NODEKTEC=1
NOEDITLINE=
NOGITHUB=1
NOHIDES=
NOPCSC=1
NORIST=1
NOSRT=1
NOTELETEXT=1
NOTEST=1
NOVATEK=1
SYSPREFIX=${TERMUX_PREFIX}
USELIB64=
CXXFLAGS_WARNINGS=
NATIVEBINDIR=$TERMUX_PKG_HOSTBUILD_DIR/bin/release
"
TERMUX_PKG_RM_AFTER_INSTALL="
etc/security
etc/udev
"

termux_step_post_get_source() {
	# Needs to call `termux_step_configure_autotools` for `*-config` hack.
	touch configure
	chmod u+x configure
}

termux_step_host_build() {
	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;
	make -j $TERMUX_PKG_MAKE_PROCESSES \
		NOCURL=1 \
		NODEKTEC=1 \
		NOEDITLINE=1 \
		NOGITHUB=1 \
		NOHIDES=1 \
		NOPCSC=1 \
		NORIST=1 \
		NOSRT=1 \
		NOTELETEXT=1 \
		NOTEST=1 \
		NOVATEK=1
}

termux_step_pre_configure() {
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/bin/release:$PATH

	CXXFLAGS+=" -fno-strict-aliasing"
	LDFLAGS+=" -landroid-glob"
}

termux_step_make() {
	sed \
		-e "s|\$(call F_SEARCH_CROSS,g++)|${CXX}|g" \
		-e "s|\$(call F_SEARCH_CROSS,gcc)|${CC}|g" \
		-e "s|\$(call F_SEARCH_CROSS,ld)|${LD}|g" \
		-i ${TERMUX_PKG_SRCDIR}/Makefile.inc
	make -j $TERMUX_PKG_MAKE_PROCESSES \
		CXX="$CXX" \
		GCC="$CC" \
		LD="$LD" \
		CXXFLAGS_CROSS="$CXXFLAGS $CPPFLAGS" \
		LDFLAGS_CROSS="$LDFLAGS" \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}
