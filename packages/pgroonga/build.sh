TERMUX_PKG_HOMEPAGE=https://github.com/pgroonga/pgroonga
TERMUX_PKG_DESCRIPTION="A PostgreSQL extension to use Groonga as index"
TERMUX_PKG_LICENSE="PostgreSQL"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.9"
TERMUX_PKG_SRCURL=https://github.com/pgroonga/pgroonga/releases/download/${TERMUX_PKG_VERSION}/pgroonga-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d9fd0d8380ef0e807683c30ea25934e0bf5cfdc9553ad17a5907b620e0cbf72
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="groonga, libmsgpack, xxhash"
TERMUX_PKG_BUILD_DEPENDS="postgresql"
TERMUX_PKG_EXTRA_MAKE_ARGS="
-Dmessage_pack=enabled
-Dtest=false
-Dxxhash=enabled
"
