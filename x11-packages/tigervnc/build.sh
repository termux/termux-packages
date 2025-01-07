TERMUX_PKG_HOMEPAGE=https://tigervnc.org/
TERMUX_PKG_DESCRIPTION="Suite of VNC servers. Based on the VNC 4 branch of TightVNC."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(1.14.1
                    21.1.8)
TERMUX_PKG_SRCURL=(https://github.com/TigerVNC/tigervnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
                   https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION[1]}.tar.xz)
TERMUX_PKG_SHA256=(579d0d04eb5b806d240e99a3c756b38936859e6f7db2f4af0d5656cc9a989d7c
                   38aadb735650c8024ee25211c190bf8aad844c5f59632761ab1ef4c4d5aeb152)
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libgmp, libgnutls, libjpeg-turbo, libnettle, libpixman, libx11, libxau, libxdamage, libxdmcp, libxext, libxfixes, libxfont2, libxrandr, libxshmfence, libxtst, opengl, openssl, perl, xkeyboard-config, xorg-xauth, xorg-xkbcomp, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorg-font-util, xorg-server-xvfb, xorg-util-macros, xorgproto, xtrans"
TERMUX_PKG_SUGGESTS="aterm, xorg-twm"

TERMUX_PKG_FOLDERNAME=tigervnc-${TERMUX_PKG_VERSION}
# Viewer has a separate package tigervnc-viewer. Do not build viewer here.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_VIEWER=OFF -DENABLE_NLS=OFF -DENABLE_PAM=OFF -DENABLE_GNUTLS=ON -DFLTK_MATH_LIBRARY="
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	## TigerVNC requires sources of X server (either Xorg or Xvfb).
	cp -r xorg-server-${TERMUX_PKG_VERSION[1]}/* unix/xserver/

	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver
	for p in "$TERMUX_SCRIPTDIR/x11-packages/xorg-server-xvfb"/*.patch; do
		echo "Applying $(basename "${p}")"
		sed -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
			-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" "$p" \
			| patch --silent -p1
	done

	patch -p1 -i ${TERMUX_PKG_BUILDER_DIR}/xserver21.1.1.diff
}

termux_step_pre_configure() {
	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver

	autoreconf -fi

	CFLAGS="${CFLAGS/-Os/-Oz} -DFNDELAY=O_NDELAY -DINITARGS=void"
	CPPFLAGS="${CPPFLAGS} -I${TERMUX_PREFIX}/include/libdrm"

	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS="${LDFLAGS} -llog -L$_libgcc_path -l:$_libgcc_name"

	local xorg_server_xvfb_configure_args="$(. $TERMUX_SCRIPTDIR/x11-packages/xorg-server-xvfb/build.sh; echo $TERMUX_PKG_EXTRA_CONFIGURE_ARGS)"
	./configure \
		--host="${TERMUX_HOST_PLATFORM}" \
		--prefix="${TERMUX_PREFIX}" \
		--disable-static \
		--disable-nls \
		--enable-debug \
		${xorg_server_xvfb_configure_args}

	LDFLAGS="${LDFLAGS} -landroid-shmem"
}

termux_step_post_make_install() {
	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver
	make -j ${TERMUX_PKG_MAKE_PROCESSES}

	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver/hw/vnc
	make install

	## use custom variant of vncserver script
	cp -f "${TERMUX_PKG_BUILDER_DIR}/vncserver" "${TERMUX_PREFIX}/bin/vncserver"
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "${TERMUX_PREFIX}/bin/vncserver"
}

termux_step_post_massage() {
	find lib -name '*.la' -delete
}
