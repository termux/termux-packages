TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.12
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/80c7f1afbcad2769f38aeb9ba6317a51/shared-mime-info-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=18b2f0fe07ed0d6f81951a5fd5ece44de9c8aeb4dc5bb20d4f595f6cc6bd403e
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-update-mimedb ac_cv_func_fdatasync=no"

termux_step_post_make_install() {
	# fix location of shared-mime-info.pc
	if [ -f "${TERMUX_PREFIX}/share/pkgconfig/shared-mime-info.pc" ]; then
		mkdir -p "${TERMUX_PREFIX}/lib/pkgconfig" || exit 1
		mv -f "${TERMUX_PREFIX}/share/pkgconfig/shared-mime-info.pc" "${TERMUX_PREFIX}/lib/pkgconfig/shared-mime-info.pc" || exit 1
	fi
}

termux_step_create_debscripts() {
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./postinst
    cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./postrm
    cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./triggers
}
