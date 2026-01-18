TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (Python bindings)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=816c96e8e8f193b40151dad7e8ff37b1221d019dbcb9c35cd3fadbfe6477dfec
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	# ERROR: ./lib/python3.12/site-packages/_brotli.cpython-312.so contains undefined symbols:
	# 31: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   UND log2
	LDFLAGS+=" -lm"
	LDFLAGS+=" -Wl,--no-as-needed -lpython${TERMUX_PYTHON_VERSION}"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	pip install . --prefix="$TERMUX_PREFIX" -vv --no-build-isolation --no-deps
}
