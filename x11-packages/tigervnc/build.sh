TERMUX_PKG_HOMEPAGE=https://tigervnc.org/
TERMUX_PKG_DESCRIPTION="Suite of VNC servers. Based on the VNC 4 branch of TightVNC."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# No update anymore. v1.11.x requires support of PAM.
TERMUX_PKG_VERSION=(1.10.1
		    21.1.7)
TERMUX_PKG_REVISION=36
TERMUX_PKG_SRCURL=(https://github.com/TigerVNC/tigervnc/archive/v${TERMUX_PKG_VERSION}.tar.gz
		   https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION[1]}.tar.xz)
TERMUX_PKG_SHA256=(19fcc80d7d35dd58115262e53cac87d8903180261d94c2a6b0c19224f50b58c4
		   d9c60b2dd0ec52326ca6ab20db0e490b1ff4f566f59ca742d6532e92795877bb)
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libgnutls, libjpeg-turbo, libpixman, libx11, libxau, libxdamage, libxdmcp, libxext, libxfixes, libxfont2, opengl, openssl, perl, xkeyboard-config, xorg-xauth, xorg-xkbcomp, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorg-font-util, xorg-server-xvfb, xorg-util-macros, xorgproto, xtrans"
TERMUX_PKG_SUGGESTS="aterm, xorg-twm"

TERMUX_PKG_FOLDERNAME=tigervnc-${TERMUX_PKG_VERSION}
# Viewer has a separate package tigervnc-viewer. Do not build viewer here.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_VIEWER=OFF -DENABLE_NLS=OFF -DENABLE_PAM=OFF -DENABLE_GNUTLS=ON -DFLTK_MATH_LIBRARY="
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local p=tigervnc-xserver21-patch.patch
	termux_download \
		"https://github.com/TigerVNC/tigervnc/commit/0c5a2b2e7759c2829c07186cfce4d24aa9b5274e.patch" \
		"$TERMUX_PKG_CACHEDIR/${p}" \
		1fd6858fbc7c67aa3ab82347c5b9dc54e3bb7a9386f373a155acbaca5d8db3c6
	echo "Applying ${p}"
	cat "$TERMUX_PKG_CACHEDIR/${p}" | patch --silent -p1

	## TigerVNC requires sources of X server (either Xorg or Xvfb).
	cp -r xorg-server-${TERMUX_PKG_VERSION[1]}/* unix/xserver/

	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver
	for p in "$TERMUX_SCRIPTDIR/x11-packages/xorg-server-xvfb"/*.patch; do
		echo "Applying $(basename "${p}")"
		sed -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
			-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" "$p" \
			| patch --silent -p1
	done

	patch -p1 -i ${TERMUX_PKG_SRCDIR}/unix/xserver21.1.1.patch
}

termux_step_pre_configure() {
	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver

	autoreconf -fi

	CFLAGS="${CFLAGS/-Os/-Oz} -DFNDELAY=O_NDELAY -DINITARGS=void"
	CPPFLAGS="${CPPFLAGS} -I${TERMUX_PREFIX}/include/libdrm"
	LDFLAGS="${LDFLAGS} -llog $($CC -print-libgcc-file-name)"

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
	make -j ${TERMUX_MAKE_PROCESSES}

	cd ${TERMUX_PKG_BUILDDIR}/unix/xserver/hw/vnc
	make install

	## use custom variant of vncserver script
	cp -f "${TERMUX_PKG_BUILDER_DIR}/vncserver" "${TERMUX_PREFIX}/bin/vncserver"
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "${TERMUX_PREFIX}/bin/vncserver"
}

termux_step_post_massage() {
	find lib -name '*.la' -delete
}
