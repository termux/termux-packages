TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${TERMUX_PKG_VERSION}/shared-mime-info-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=531291d0387eb94e16e775d7e73788d06d2b2fdd8cd2ac6b6b15287593b6a2de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2"

termux_step_create_debscripts() {
	cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./postinst
	cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./postrm
	cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./triggers
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./{post{inst,rm},triggers}
}
