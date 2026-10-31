TERMUX_PKG_HOMEPAGE=https://rogerbinns.github.io/apsw/
TERMUX_PKG_DESCRIPTION="Another Python SQLite Wrapper"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.54.1.0"
TERMUX_PKG_SRCURL=https://github.com/rogerbinns/apsw/releases/download/${TERMUX_PKG_VERSION}/apsw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04375f08cf1df80949eeb79920ad1cdde08e617a7fd3e5442a4524ef1c3f2ec8
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
