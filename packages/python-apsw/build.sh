TERMUX_PKG_HOMEPAGE=https://github.com/rogerbinns/apsw/
TERMUX_PKG_DESCRIPTION="Another Python SQLite Wrapper"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.47.2.0"
TERMUX_PKG_SRCURL=https://github.com/rogerbinns/apsw/releases/download/${TERMUX_PKG_VERSION}/apsw-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=22425dc6d4853611202a6f0a303d3405ee84622622256dd2a73b4e6be05e6e91
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsqlite, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/setup.cfg ./
}

termux_step_make() {
	:
}
