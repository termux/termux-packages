TERMUX_PKG_HOMEPAGE=https://github.com/couchbase/forestdb
TERMUX_PKG_DESCRIPTION="A key-value storage engine"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/couchbase/forestdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=52463e4e3bd94ff70503b8a278ec0304c13acb6862e5d5fd3d2b3f05e60b7aa0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libsnappy"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_configure() {
	if [ "$TERMUX_PKG_CMAKE_BUILD" == "Ninja" ]; then
		sed -i -e 's:\$INCLUDES:& -I'$TERMUX_PREFIX'/include:g' \
			CMakeFiles/rules.ninja
	fi
}
