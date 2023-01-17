TERMUX_PKG_HOMEPAGE=https://github.com/rogerbinns/apsw/
TERMUX_PKG_DESCRIPTION="Another Python SQLite Wrapper"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.40.1.0
TERMUX_PKG_SRCURL=https://github.com/rogerbinns/apsw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0fe57bcd1ebc0439a1d95cad1716c6492dab81824c79e01101a72862eb18473
TERMUX_PKG_DEPENDS="libsqlite, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/setup.cfg ./
}

termux_step_make() {
	:
}
