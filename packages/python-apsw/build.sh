TERMUX_PKG_HOMEPAGE=https://rogerbinns.github.io/apsw/
TERMUX_PKG_DESCRIPTION="Another Python SQLite Wrapper"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.53.3.0"
TERMUX_PKG_SRCURL=https://github.com/rogerbinns/apsw/releases/download/${TERMUX_PKG_VERSION}/apsw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95132334cc49cc13fcb00d9bbfa591661a8a22c7534061e2bd27a31355b8bf9e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsqlite, python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/setup.cfg ./
}

termux_step_make() {
	:
}
