TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${TERMUX_PKG_VERSION}/shared-mime-info-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea248ea157b7fa0165f4fe282c84919fa84c3f175553642f229c8f1ab7539128
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2"

termux_step_create_debscripts() {
	for i in $(test "$TERMUX_PACKAGE_FORMAT" != "pacman" && echo postinst) postrm triggers; do
		cp "${TERMUX_PKG_BUILDER_DIR}/${i}" ./${i}
		sed -i -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
			-e "s|@TERMUX_PACKAGE_FORMAT@|${TERMUX_PACKAGE_FORMAT}|g" ./${i}
	done
	unset i
}
