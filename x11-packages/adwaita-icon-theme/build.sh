TERMUX_PKG_HOMEPAGE=https://www.gnome.org
TERMUX_PKG_DESCRIPTION="GNOME standard icons"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=40.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/adwaita-icon-theme/-/archive/${TERMUX_PKG_VERSION}/adwaita-icon-theme-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a13f97bf12eb24b00a72335c37324ac51556050115d7b3fdcdb83f081039d28
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
