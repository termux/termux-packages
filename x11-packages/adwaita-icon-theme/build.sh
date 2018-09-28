TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://www.gnome.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org Hicolor icon theme"
TERMUX_PKG_VERSION=3.30.0
TERMUX_PKG_SRCURL=https://github.com/GNOME/adwaita-icon-theme/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=14b70916d763f841865c295b4d6dd0aebba6f0829a29c019348d0f775178aeba
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme"

termux_step_pre_configure() {
    autoreconf -fvi
}

termux_step_post_make_install() {
    # fix location of adwaita-icon-theme.pc
    if [ -f "${TERMUX_PREFIX}/share/pkgconfig/adwaita-icon-theme.pc" ]; then
        mkdir -p "${TERMUX_PREFIX}/lib/pkgconfig" || exit 1
        mv -f "${TERMUX_PREFIX}/share/pkgconfig/adwaita-icon-theme.pc" "${TERMUX_PREFIX}/lib/pkgconfig/adwaita-icon-theme.pc" || exit 1
    fi
}
