TERMUX_PKG_HOMEPAGE=https://astyle.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Source code formatter for C-like programming languages"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.18"
TERMUX_PKG_SRCURL="https://gitlab.com/saalen/astyle/-/archive/${TERMUX_PKG_VERSION}/astyle-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3cf671a726e9b14e75fd9ad862dc6b5500f948a12700bc842e9bd4bc3a9a9915
TERMUX_PKG_AUTO_UPDATE=true

# NOTE: Do not pass -DBUILD_SHARED_LIBS=ON. Upstream CMake builds
# *either* the shared library *or* the CLI executable, never both,
# so the shared flag produces a lib-only package without bin/astyle
# (see https://github.com/termux/termux-packages/issues/31705).
# The default build produces the astyle executable.

termux_step_post_get_source() {
	# There is an experimental wxWidgets based GUI.
	# But We're only interested in the CLI.
	TERMUX_PKG_SRCDIR+="/AStyle"
}
