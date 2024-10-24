TERMUX_PKG_HOMEPAGE=https://www.panda3d.org/
TERMUX_PKG_DESCRIPTION="A framework for 3D rendering and game development for Python and C++ programs"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.14"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/panda3d/panda3d/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ff568db545102f87d3e1191ba6a2f3cdc97ff2f62056973cf354743dd880591
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/panda3d"

	# makewheel.py requires ldd, host ldd does not work with bionic libraries.
	mkdir "$TERMUX_PKG_TMPDIR/bin"
	echo "#!/bin/bash" > "$TERMUX_PKG_TMPDIR/bin/ldd"
	echo "readelf -d \$1 | grep \"NEEDED\" | awk '{ gsub(/\[|\]/, \"\", \$NF); print \$NF, \"NEEDED\" }'" >> "$TERMUX_PKG_TMPDIR/bin/ldd"
	chmod +x "$TERMUX_PKG_TMPDIR/bin/ldd"
	PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
}

termux_step_make() {
	python makepanda/makepanda.py --nothing --wheel --use-python
}

termux_step_make_install() {
	python makepanda/installpanda.py --prefix $TERMUX_PREFIX

	local _pyv="${TERMUX_PYTHON_VERSION/./}"
	local _whl="panda3d-$TERMUX_PKG_VERSION-cp$_pyv-cp$_pyv-linux_$TERMUX_ARCH.whl"
	pip install --no-deps --prefix=$TERMUX_PREFIX --force-reinstall $TERMUX_PKG_SRCDIR/$_whl

	# For some reason it packages python libraries of host.
	rm -rf $TERMUX_PREFIX/lib/python${TERMUX_PYTHON_VERSION}/site-packages/deploy_libs
}
