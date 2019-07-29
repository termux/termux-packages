TERMUX_PKG_HOMEPAGE=https://www.gnome.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org Hicolor icon theme"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.32.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/GNOME/adwaita-icon-theme/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1b514674692030feb57d078b8f20011bb0f79be28419bb2fb494d81ef26e5638
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
