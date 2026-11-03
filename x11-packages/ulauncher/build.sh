TERMUX_PKG_HOMEPAGE=https://ulauncher.io
TERMUX_PKG_DESCRIPTION="Fast application launcher for Linux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=5.16.2
# Git tag archive lacks the prebuilt preferences web app; use the
# upstream release tarball which ships data/preferences/dist.
TERMUX_PKG_SRCURL=https://github.com/Ulauncher/Ulauncher/releases/download/5.16.2/ulauncher_5.16.2.tar.gz
TERMUX_PKG_SHA256=5a229f51180c756fda68d2adb764e1653fef1f4b5f05afa01b3163725f6adaac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus-python, gdk-pixbuf, glib, gtk3, keybinder, libnotify, pygobject, python, python-levenshtein, python-pip, python-pyinotify, webkit2gtk-4.1"
TERMUX_PKG_BUILD_DEPENDS="python-distutils-extra"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, build, setuptools"
TERMUX_PKG_PYTHON_TARGET_DEPS="'pyxdg', 'websocket-client'"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/systemd"

termux_step_post_get_source() {
	# Like upstream's build-targz.sh: the tag tarball keeps
	# placeholders instead of the release version.
	sed -i "s/__version__ =.*/__version__ = '$TERMUX_PKG_VERSION'/" ulauncher/config.py
	sed -i "s/%VERSION%/$TERMUX_PKG_VERSION/" setup.py
}

termux_step_make() {
	# --no-isolation so setup.py can import DistUtilsExtra from the
	# build prefix (unavailable on PyPI, must come from our package).
	PYTHONPATH="$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages" \
		python -m build -w -n -x "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"/dist/ulauncher-*.whl
}

termux_step_post_make_install() {
	sed -i "s|^__ulauncher_data_directory__ =.*|__ulauncher_data_directory__ = '$TERMUX_PREFIX/share/ulauncher'|" \
		"$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages/ulauncher/config.py"
}
