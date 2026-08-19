TERMUX_PKG_HOMEPAGE="https://www.qt.io"
TERMUX_PKG_DESCRIPTION="Qt HTTP Server"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.2"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qthttpserver-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f0f5763b2ba58f20f5cffdfbedb97e62e32b5c639df6d9a6378905028be7bd8e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='v\d+\.\d+\.\d+(?!-)'
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtwebsockets"
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
