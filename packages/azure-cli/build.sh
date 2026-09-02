TERMUX_PKG_HOMEPAGE="https://learn.microsoft.com/en-us/cli/azure/"
TERMUX_PKG_DESCRIPTION="Microsoft's command-line tool for managing Azure cloud resources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.90.0"
TERMUX_PKG_SRCURL="https://github.com/Azure/azure-cli/archive/refs/tags/azure-cli-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2d7caf68257fe6a6a7811219f940aa0b1d76b9d3adddca9482236e62c5697a7d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="python, python-pip, python-cryptography, python-psutil, python-bcrypt, python-pynacl"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="azure-cli, azure-cli-core, azure-cli-telemetry"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools, wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	local _src="$TERMUX_PKG_SRCDIR/src"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$_src/azure-cli-telemetry"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$_src/azure-cli-core"
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$_src/azure-cli"
}
