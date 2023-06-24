TERMUX_PKG_HOMEPAGE=https://github.com/chrisstaite/lameenc
TERMUX_PKG_DESCRIPTION="Python bindings around the LAME encoder"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/chrisstaite/lameenc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c8a56be642953661a3edf1b31307e5f6802fa02cb47f83146eb3bc356aa5ca5
TERMUX_PKG_DEPENDS="libmp3lame, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -rf build dist
}

termux_step_configure() {
	:
}

termux_step_make() {
	python setup.py \
		--libdir=$TERMUX_PREFIX/lib \
		--incdir=$TERMUX_PREFIX/include/lame \
		bdist_wheel
}

termux_step_make_install() {
	local f
	for f in dist/lameenc-${TERMUX_PKG_VERSION#*:}-*.whl; do
		if [ -e "${f}" ]; then
			pip install --force "${f}" --prefix $TERMUX_PREFIX
			break
		fi
	done
}
