TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Xorg server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# Keep version of `tigervnc` package aligned with this package, revbump tigervnc after modifying patches of this package
TERMUX_PKG_VERSION="21.1.16"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b14a116d2d805debc5b5b2aac505a279e69b217dae2fae2dfcb62400471a9970
# We can not update it automatically because tigervnc server version must be aligned with xorg-server.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libpciaccess, libpixman, libx11, libxau, libxcvt, libxfont2, libxinerama, libxkbfile, libxshmfence, opengl, openssl, xkeyboard-config, xorg-protocol-txt, xorg-xkbcomp"
TERMUX_PKG_BUILD_DEPENDS="mesa-dev"

# Needed for Xephyr
TERMUX_PKG_BUILD_DEPENDS="xcb-util, xcb-util-image, xcb-util-keysyms, xcb-util-renderutil, xcb-util-wm"

TERMUX_PKG_RECOMMENDS="xf86-video-dummy, xf86-input-void"
TERMUX_PKG_NO_STATICSPLIT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_RAWCPP=/usr/bin/cpp
--enable-composite
--enable-mitshm
--enable-xres
--enable-record
--enable-xv
--enable-xvmc
--enable-dga
--enable-screensaver
--enable-xdmcp
--enable-glx
--disable-dri
--disable-dri2
--enable-dri3
--enable-present
--disable-tests
--enable-xinerama
--enable-xf86vidmode
--enable-xace
--enable-xcsecurity
--enable-dbe
--enable-xf86bigfont
--disable-xfree86-utils
--disable-vgahw
--disable-vbe
--disable-int10-module
--enable-libdrm
--disable-pciaccess
--disable-linux-acpi
--disable-linux-apm
--enable-xorg
--disable-glamor
--disable-dmx
--enable-xvfb
--disable-xnest
--disable-xwayland
--disable-xwin
--enable-kdrive
--enable-xephyr
--disable-libunwind
--enable-xshmfence
--enable-ipv6
--with-sha1=libcrypto
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
--with-xkb-path=${TERMUX_PREFIX}/share/X11/xkb
LIBS=-landroid-shmem"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon -fPIC -DFNDELAY=O_NDELAY -Wno-int-to-pointer-cast"
	CPPFLAGS+=" -fcommon -fPIC -I${TERMUX_PREFIX}/include/libdrm"

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-debug"
	fi

	# fixing automake version mismatch
	cd ${TERMUX_PKG_SRCDIR}
	files=`find . -name configure -o -name config.status -o -name Makefile.in`
	for file in $files; do rm $file; done
	unset files

	# you will need xutils-dev package for xorg-macros installed
	autoreconf -if
	cd -

	local XVFB_RUN_URL="https://salsa.debian.org/xorg-team/xserver/xorg-server/-/raw/debian-bookworm/debian/local/xvfb-run"
	termux_download ${XVFB_RUN_URL} "${TERMUX_PKG_CACHEDIR}/xvfb-run" fd05e0f8e6207c3984b980a0f037381c9c4a6f22a6dd94fdcfa995318db2a0a4
	sed -i "1s|.*|#!$TERMUX_PREFIX/bin/bash|" "${TERMUX_PKG_CACHEDIR}/xvfb-run"
}

termux_step_post_make_install () {
	rm -f "${TERMUX_PREFIX}/usr/share/X11/xkb/compiled"
	install -Dm644 -t "${TERMUX_PREFIX}/etc/X11/" "${TERMUX_PKG_BUILDER_DIR}/xorg.conf"
	install -Dm755 "${TERMUX_PKG_CACHEDIR}/xvfb-run" "${TERMUX_PREFIX}/bin/"
}

## The following is required for package 'tigervnc'.
if [ "${#}" -eq 1 ] && [ "${1}" == "xorg_server_flags" ]; then
	echo ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
	return
fi
