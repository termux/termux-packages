TERMUX_PKG_HOMEPAGE=https://github.com/rogerbinns/apsw/
TERMUX_PKG_DESCRIPTION="Another Python SQLite Wrapper"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.41.0.0
TERMUX_PKG_SRCURL=https://github.com/rogerbinns/apsw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7edb3a21c808b01a273baff9a2683752456a28b464df413cac1eb4ceed4be971
TERMUX_PKG_DEPENDS="libsqlite, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/setup.cfg ./
}

termux_step_make() {
	:
}
