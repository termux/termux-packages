TERMUX_PKG_HOMEPAGE="https://www.qt.io"
TERMUX_PKG_DESCRIPTION="Qt6 module for speech functionality"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.12.1"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtspeech-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9df7bab664597abf09d5f3a012a487545125e2a2f8b585681ccfd184d9eacdbd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='v\d+\.\d+\.\d+(?!-)'
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtmultimedia, speechd"
TERMUX_PKG_BUILD_DEPENDS="cmake, git, ninja, qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"

termux_pkg_auto_update() {
	# use GitHub API for Qt packages because Repology is unreliable for Qt
	# All Qt updates are published by upstream simultaneously, so the qtbase
	# repository can be used for all Qt packages
	local latest_tags
	latest_tags="$(
		TERMUX_PKG_SRCURL="https://github.com/qt/qtbase" \
		termux_github_api_get_tag
	)"

	termux_pkg_upgrade_version "${latest_tags}"
}
