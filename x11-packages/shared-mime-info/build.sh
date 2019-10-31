TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.14
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/Release-${TERMUX_PKG_VERSION//./-}/shared-mime-info-Release-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=2029d4d9e21dada5f7f68aaf791df51ea3885c3087c8d46572416b0882f8d7e3
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-update-mimedb ac_cv_func_fdatasync=no"

termux_step_pre_configure() {
	NOCONFIGURE=1 bash ./autogen.sh
}

termux_step_post_make_install() {
	# fix location of shared-mime-info.pc
	if [ -f "${TERMUX_PREFIX}/share/pkgconfig/shared-mime-info.pc" ]; then
		mkdir -p "${TERMUX_PREFIX}/lib/pkgconfig"
		mv -f "${TERMUX_PREFIX}/share/pkgconfig/shared-mime-info.pc" "${TERMUX_PREFIX}/lib/pkgconfig/shared-mime-info.pc"
	fi
}

termux_step_create_debscripts() {
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./postinst
    cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./postrm
    cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./triggers
}
