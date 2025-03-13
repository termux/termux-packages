TERMUX_PKG_HOMEPAGE=https://github.com/Imagick/imagick
TERMUX_PKG_DESCRIPTION="The Imagick PHP extension"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="ian4hu <hu2008yinxiang@163.com>"
TERMUX_PKG_VERSION=3.7.0
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/Imagick/imagick/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aa2e311efb7348350c7332876252720af6fb71210d13268de765bc41f51128f9
TERMUX_PKG_DEPENDS="php, imagemagick"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+'
TERMUX_PKG_UPDATE_TAG_TYPE="latest-regex"

termux_pkg_auto_update() {
	#
	local latest_release
	latest_release="$(termux_github_api_get_tag \
		"${TERMUX_PKG_SRCURL}" \
		"${TERMUX_PKG_UPDATE_TAG_TYPE}" \
		"${TERMUX_PKG_UPDATE_VERSION_REGEXP}"
	)"

	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	termux_pkg_upgrade_version "${latest_release}"
}

termux_step_pre_configure() {
	$TERMUX_PREFIX/bin/phpize

	if [ "$TERMUX_ARCH_BITS" = 32 ];then
		LDFLAGS+=" -lm"
	fi
}
