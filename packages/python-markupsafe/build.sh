TERMUX_PKG_HOMEPAGE=https://palletsprojects.com/p/markupsafe/
TERMUX_PKG_DESCRIPTION="Safely add untrusted strings to HTML/XML markup"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.3"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/M/MarkupSafe/markupsafe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, setuptools, wheel"

termux_step_make() {
	PYTHONPATH='' python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	# The wheel file name depends on how setuptools normalises the project name,
	# which has changed across releases, so match it instead of rebuilding it.
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" \
		"$TERMUX_PKG_SRCDIR"/dist/*.whl
}
