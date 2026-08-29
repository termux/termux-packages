TERMUX_PKG_HOMEPAGE=https://www.riverbankcomputing.com/software/sip/
TERMUX_PKG_DESCRIPTION="The sip extension module for PyQt6"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.12.0"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/P/PyQt6-sip/pyqt6_sip-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a7ad45c1e3cec3a2473d37ea9870b6c3baeccc560298623c8eb59265714c06e2
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, setuptools, wheel"

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	# The wheel file name follows the project name's normalisation, which has
	# changed across releases, so match it instead of reconstructing it.
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" \
		"$TERMUX_PKG_SRCDIR"/dist/*.whl
}
