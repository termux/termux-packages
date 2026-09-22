TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libbluray/
TERMUX_PKG_DESCRIPTION="An open-source library designed for Blu-Ray Discs playback for media players"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/libbluray/-/archive/${TERMUX_PKG_VERSION}/libbluray-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ee46f99adc591d18a9485b404cb04be6ba6fcde5bd45590ea94d0c1432d448c9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, libudfread, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbdj_jar=disabled
"

termux_pkg_auto_update() {
	local url="https://code.videolan.org/videolan/libbluray/-/tags?sort=updated_desc" latest_version
	latest_version="$(curl --fail --silent --show-error --location --retry 5 "$url" | sed -rn 's|.*href="/videolan/libbluray/-/tags/([0-9]+(\.[0-9]+)+)".*|\1|p' | sort -Vr | head -n1)"
	if [[ -z "$latest_version" ]]; then
		termux_error_exit "Unable to get the latest libbluray version."
	fi
	termux_pkg_upgrade_version "$latest_version"
}

termux_step_pre_configure() {
	unset JDK_HOME
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _GUARD_FILE="lib/libbluray.so.4"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
