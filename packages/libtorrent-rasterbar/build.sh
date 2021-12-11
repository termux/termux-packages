TERMUX_PKG_HOMEPAGE=https://libtorrent.org/
TERMUX_PKG_DESCRIPTION="A feature complete C++ bittorrent implementation focusing on efficiency and scalability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.5
TERMUX_PKG_SRCURL=https://github.com/arvidn/libtorrent/releases/download/v${TERMUX_PKG_VERSION}/libtorrent-rasterbar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e965c2e53170c61c0db3a2d898a61769cb7acd541bbf157cbbef97a185930ea5
TERMUX_PKG_DEPENDS="boost, openssl, python"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dboost-python-module-name=python
-Dpython-bindings=ON
"

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
}

termux_step_create_debscripts() {
	local pyext_orig="$TERMUX_PREFIX/lib/python${_PYTHON_VERSION%.*}/dist-packages/libtorrent.so"
	local pyext_symlink="$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/libtorrent.so"

	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pyext_orig=\"$pyext_orig\"" >> postinst
	echo "pyext_symlink=\"$pyext_symlink\"" >> postinst
	echo "mkdir -p \"\$(dirname \"\$pyext_symlink\")\"" >> postinst
	echo "if [ ! -e \"\$pyext_symlink\" ]; then" >> postinst
	echo "  ln -sf \"\$pyext_orig\" \"\$pyext_symlink\"" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst

	echo "#!$TERMUX_PREFIX/bin/sh" > prerm
	echo "pyext_orig=\"$pyext_orig\"" >> prerm
	echo "pyext_symlink=\"$pyext_symlink\"" >> prerm
	echo "if [ -L \"\$pyext_symlink\" ]; then" >> prerm
	echo "  if [ \"\$(readlink \"\$pyext_symlink\")\" == \"\$pyext_orig\" ]; then" >> prerm
	echo "    rm -f \"\$pyext_symlink\"" >> prerm
	echo "  fi" >> prerm
	echo "fi" >> prerm
	echo "exit 0" >> prerm
	chmod 0755 prerm
}
