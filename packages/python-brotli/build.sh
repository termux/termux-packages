TERMUX_PKG_HOMEPAGE=https://github.com/google/brotli
TERMUX_PKG_DESCRIPTION="lossless compression algorithm and format (Python bindings)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/google/brotli/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
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
