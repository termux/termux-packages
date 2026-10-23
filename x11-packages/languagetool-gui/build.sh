TERMUX_PKG_HOMEPAGE=https://languagetool.org
TERMUX_PKG_DESCRIPTION="GUI version of languagetool"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="$(
	source "${TERMUX_SCRIPTDIR}/packages/languagetool-libs/build.sh"
	echo "${TERMUX_PKG_VERSION}"
)"
TERMUX_PKG_SRCURL="$(
	source "${TERMUX_SCRIPTDIR}/packages/languagetool-libs/build.sh"
	echo "${TERMUX_PKG_SRCURL}"
)"
TERMUX_PKG_SHA256="$(
	source "${TERMUX_SCRIPTDIR}/packages/languagetool-libs/build.sh"
	echo "${TERMUX_PKG_SHA256}"
)"
TERMUX_PKG_DEPENDS="openjdk-17 | openjdk-21, openjdk-17-x | openjdk-21-x, languagetool-libs"
TERMUX_PKG_ANTI_BUILD_DEPENDS="openjdk-17, openjdk-17-x, openjdk-21, openjdk-21-x"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mv ./languagetool.jar "${TERMUX_PREFIX}/share/java/languagetool"
	sed "s|@MAIN@|org.languagetool.gui.Main|g" "${TERMUX_SCRIPTDIR}/packages/languagetool-libs/languagetool.sh" > "${TERMUX_PREFIX}/bin/languagetool-gui"
	chmod 700 "${TERMUX_PREFIX}/bin/languagetool-gui"
}
