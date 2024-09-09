TERMUX_PKG_HOMEPAGE=https://github.com/lxml/lxml
TERMUX_PKG_DESCRIPTION="Python binding for the libxml2 and libxslt libraries"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.3.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lxml/lxml/releases/download/lxml-$TERMUX_PKG_VERSION/lxml-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_pkg_auto_update() {
	local tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"
	if grep -qP "^lxml-${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not stable release($tag)"
	fi
}
