TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING.GPL3, COPYING.LGPL3, COPYING.XTERM"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:0.74.1"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/vte/-/archive/${TERMUX_PKG_VERSION:2}/vte-${TERMUX_PKG_VERSION:2}.tar.bz2
#TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/vte/${_MAJOR_VERSION}/vte-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=193496182428a34cfe555ee3df7ac6185de7eb7fc4af60b5dd175be46854b21a
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, gtk4, libc++, libcairo, libgnutls, libicu, pango, pcre2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, bionic-host, ldd, glib-cross"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=true
-Dvapi=false
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX -Wno-cast-function-type-strict -Wno-deprecated-declarations"
	mkdir -p ${TERMUX_PKG_TMPDIR}/bin

		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${TERMUX_PKG_TMPDIR}/bin/pkg-config"
		chmod +x "${TERMUX_PKG_TMPDIR}/bin/pkg-config"
		export PKG_CONFIG="${TERMUX_PKG_TMPDIR}/bin/pkg-config"
	
	
	for i in ldd; do
	    echo -e "#!/bin/sh\nunset LD_LIBRARY_PATH\nexec $TERMUX_PREFIX/bin/$i \"\$@\"" > ${TERMUX_PKG_TMPDIR}/bin/$i \
	        && chmod +x ${TERMUX_PKG_TMPDIR}/bin/$i
	done
	for i in bash $CC $CXX $AR $LD $STRIP; do 
	    echo -e "#!/bin/sh\nunset LD_LIBRARY_PATH\nexec $(command -v $i) \"\$@\"" > ${TERMUX_PKG_TMPDIR}/bin/$i \
	        && chmod +x ${TERMUX_PKG_TMPDIR}/bin/$i
	done
	export PATH="${TERMUX_PKG_TMPDIR}/bin:$PATH"
}
