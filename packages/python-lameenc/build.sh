TERMUX_PKG_HOMEPAGE=https://github.com/chrisstaite/lameenc
TERMUX_PKG_DESCRIPTION="Python bindings around the LAME encoder"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.3"
TERMUX_PKG_SRCURL=https://github.com/chrisstaite/lameenc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fc7d448327259c0784e4cf9ac73931e457ecb3e94a4dfae297149f0e350cef7b
TERMUX_PKG_AUTO_UPDATE=true
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
