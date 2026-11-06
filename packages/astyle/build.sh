TERMUX_PKG_HOMEPAGE=https://astyle.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Source code formatter for C-like programming languages"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.22"
TERMUX_PKG_SRCURL="https://gitlab.com/saalen/astyle/-/archive/${TERMUX_PKG_VERSION}/astyle-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1116a77eab2f4466ee399ee2af046c5a501f1429089b1d5e0c97e0ca33de5336
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	# There is an experimental wxWidgets based GUI.
	# But We're only interested in the CLI.
	TERMUX_PKG_SRCDIR+="/AStyle"
}

# based on the secondary `-shared` build in `libncnn`
termux_step_post_make_install() {
	echo "termux - building libastyle.so for arch ${TERMUX_ARCH}..."
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DBUILD_SHARED_LIBS=ON"
	termux_step_configure
	termux_step_make
	termux_step_make_install
}
