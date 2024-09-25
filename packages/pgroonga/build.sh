TERMUX_PKG_HOMEPAGE=https://github.com/pgroonga/pgroonga
TERMUX_PKG_DESCRIPTION="A PostgreSQL extension to use Groonga as index"
TERMUX_PKG_LICENSE="PostgreSQL"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.3"
TERMUX_PKG_SRCURL=https://github.com/pgroonga/pgroonga/releases/download/${TERMUX_PKG_VERSION}/pgroonga-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93df838222f3536700de3bf0de9305eff1660c6c6c098b4039a52d7f62cc4e7c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="groonga, libmsgpack, xxhash"
TERMUX_PKG_BUILD_DEPENDS="postgresql"
TERMUX_PKG_EXTRA_MAKE_ARGS="
HAVE_MSGPACK=1
HAVE_XXHASH=1
MSGPACK_PACKAGE_NAME=msgpack-c
PG_CONFIG=${TERMUX_PREFIX}/bin/pg_config
"

termux_step_pre_configure() {
	# CMake files are broken
	mv CMakeLists.txt{,.unused}
}
