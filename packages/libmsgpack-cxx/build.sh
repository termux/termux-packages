TERMUX_PKG_HOMEPAGE=https://msgpack.org/
TERMUX_PKG_DESCRIPTION="msgpack for C++"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.0"
TERMUX_PKG_SRCURL=https://github.com/msgpack/msgpack-c/releases/download/cpp-${TERMUX_PKG_VERSION}/msgpack-cxx-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23ede7e93c8efee343ad8c6514c28f3708207e5106af3b3e4969b3a9ed7039e7
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	# check if this is not a c release:
	if grep -qP "^cpp-${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a cpp release($tag)"
	fi
}
