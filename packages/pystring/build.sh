TERMUX_PKG_HOMEPAGE=https://github.com/imageworks/pystring
TERMUX_PKG_DESCRIPTION="C++ functions matching the interface and behavior of python string methods with std::string"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://github.com/imageworks/pystring/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=020a603a757ba1e429f4b1ea6feb3afbe0fb34bcafa355032e1f1b8a0019d198
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/include/pystring \
		$TERMUX_PKG_SRCDIR/pystring.h
}
