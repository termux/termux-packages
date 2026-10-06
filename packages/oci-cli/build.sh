TERMUX_PKG_HOMEPAGE=https://github.com/oracle/oci-cli
TERMUX_PKG_DESCRIPTION="Command line interface for Oracle Cloud Infrastructure"
TERMUX_PKG_LICENSE="UPL-1.0, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.94.2"
TERMUX_PKG_SRCURL="https://github.com/oracle/oci-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5c3c88a3ce6f8b30d3f364bec8c0e04e638ea1878b7aa2e49c385b1e47101e8d
TERMUX_PKG_DEPENDS="python, python-pip, python-cryptography, python-crc32c"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="oci-cli"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	:
}

termux_step_make_install() {
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}

termux_step_post_make_install() {
	install -Dm644 \
		"$TERMUX_PKG_SRCDIR/src/oci_cli/bin/oci_autocomplete.sh" \
		"$TERMUX_PREFIX/etc/bash_completion.d/oci_autocomplete.sh"
}
