TERMUX_PKG_HOMEPAGE=https://www.gnome.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org Hicolor icon theme"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.34.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/GNOME/adwaita-icon-theme/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=53e91a6bcc2220a125275573258374dc83dea4aa1008cbdde30ee87f1d433eb6
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/Adwaita/icon-theme.cache"

termux_step_pre_configure() {
	autoreconf -fvi
}

termux_step_post_make_install() {
	# fix location of adwaita-icon-theme.pc
	if [ -f "${TERMUX_PREFIX}/share/pkgconfig/adwaita-icon-theme.pc" ]; then
		mkdir -p "${TERMUX_PREFIX}/lib/pkgconfig"
		mv -f "${TERMUX_PREFIX}/share/pkgconfig/adwaita-icon-theme.pc" "${TERMUX_PREFIX}/lib/pkgconfig/adwaita-icon-theme.pc"
	fi
}
