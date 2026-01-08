TERMUX_PKG_HOMEPAGE="https://www.pell.portland.or.us/~orc/Code/discount/"
TERMUX_PKG_DESCRIPTION="Markdown implementation written in C"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.1.2"
TERMUX_PKG_SRCURL="https://github.com/Orc/discount/archive/v${TERMUX_PKG_VERSION}/discount-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4ea6cc8782c6508b3051c469ed7a1b6ca20b023c2a0c26ccd9c83bc7e61dfc16
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DBUILD_SHARED_LIBS=ON
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake "$TERMUX_PKG_SRCDIR/cmake" -GNinja $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	TERMUX_PKG_SRCDIR+="/cmake"
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR+=/..
}
