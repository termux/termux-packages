TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${TERMUX_PKG_VERSION}/shared-mime-info-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29b967f05318170fcd61ddfcaa28d5b68139b8385abf892aad5999bddea2610b
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
