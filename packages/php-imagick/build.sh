# Contributor: @ian4hu
TERMUX_PKG_HOMEPAGE=https://github.com/Imagick/imagick
TERMUX_PKG_DESCRIPTION="The Imagick PHP extension"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION=3.8.0
TERMUX_PKG_SRCURL=https://github.com/Imagick/imagick/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a964e54a441392577f195d91da56e0b3cf30c32e6d60d0531a355b37bb1e1a59
TERMUX_PKG_DEPENDS="php, imagemagick"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+'
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}")"

	if ! grep -P "^${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$latest_release"; then
		echo "WARN: '$latest_release' did not match the regex exclusively. Not updating."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize

	if [ "$TERMUX_ARCH_BITS" = 32 ]; then
		LDFLAGS+=" -lm"
	fi
}
