TERMUX_PKG_HOMEPAGE="https://www.pell.portland.or.us/~orc/Code/discount/"
TERMUX_PKG_DESCRIPTION="Markdown implementation written in C"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.2.0"
TERMUX_PKG_SRCURL="https://github.com/Orc/discount/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=99f6db36d3fff6c99acd21d4c6096176d4ac8785eab319d0faf77ad995b8b7c5
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

	# from configure.sh
	export CFLAGS+=" -DMAX_RECURSION=200"

	cmake "$TERMUX_PKG_SRCDIR/cmake" -GNinja $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	export CFLAGS+=" -DMAX_RECURSION=200"
	TERMUX_PKG_SRCDIR+="/cmake"
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR+=/..
}
