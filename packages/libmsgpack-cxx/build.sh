TERMUX_PKG_HOMEPAGE=https://msgpack.org/
TERMUX_PKG_DESCRIPTION="msgpack for C++"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1.1"
TERMUX_PKG_SRCURL=https://github.com/msgpack/msgpack-c/releases/download/cpp-${TERMUX_PKG_VERSION}/msgpack-cxx-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8115c5edcf20bc1408c798a6bdaec16c1e52b1c34859d4982a0fb03300438f0b
TERMUX_PKG_DEPENDS="boost"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	# check if this is not a c release:
	if grep -qP "^cpp-${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		pkg_dir=$(dirname "$0") termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a cpp release($tag)"
	fi
}
