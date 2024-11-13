TERMUX_PKG_HOMEPAGE=https://languagetool.org
TERMUX_PKG_DESCRIPTION="Libraries needed for languagetool"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.5
TERMUX_PKG_SRCURL=https://languagetool.org/download/LanguageTool-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=27f3ae5a29efbc8267a5a266908dfec205d16d312af8516e0b5bcec871edea0b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/java/languagetool/libs"
	mv ./languagetool-{commandline,server}.jar "${TERMUX_PREFIX}/share/java/languagetool"
	mv ./libs/*.jar "${TERMUX_PREFIX}/share/java/languagetool/libs"

	for pair in \
		"languagetool org.languagetool.commandline.Main" \
		"languagetool-http-server org.languagetool.server.HTTPServer" \
		"languagetool-https-server org.languagetool.server.HTTPSServer"; do
		read -r bin package <<<"$pair"
		sed "s|@MAIN@|$package|g" "${TERMUX_PKG_BUILDER_DIR}/languagetool.sh" > "${TERMUX_PREFIX}/bin/$bin"
		chmod 700 "${TERMUX_PREFIX}/bin/$bin"
	done
}
