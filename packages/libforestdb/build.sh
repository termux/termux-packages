TERMUX_PKG_HOMEPAGE=https://github.com/couchbase/forestdb
TERMUX_PKG_DESCRIPTION="A key-value storage engine"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.5
TERMUX_PKG_SRCURL=https://github.com/couchbase/forestdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2483ac9934d5d6b74623d460d98c987b7d9cd0479d9bb6f7beadb7f73de41352
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsnappy"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(git ls-remote --tags --refs "${TERMUX_PKG_HOMEPAGE}" 'refs/tags/v7.0.*' |
		sed -n 's|.*refs/tags/v\(7\.0\.[0-9]*\)$|\1|p' | sort -V | tail -n1)"
	[[ -n "${latest_tag}" ]] || termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_post_configure() {
	if [ "$TERMUX_PKG_CMAKE_BUILD" == "Ninja" ]; then
		sed -i -e 's:\$INCLUDES:& -I'$TERMUX_PREFIX'/include:g' \
			CMakeFiles/rules.ninja
	fi
}
