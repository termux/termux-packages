TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${TERMUX_PKG_VERSION}/shared-mime-info-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3aeeee25ad445f257f614ed53837dee79fab70524b56e59b767f0d69e11fdff9
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2"

termux_step_create_debscripts() {
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./postinst
    cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./postrm
    cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./triggers
}
