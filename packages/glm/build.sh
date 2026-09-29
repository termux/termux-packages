TERMUX_PKG_HOMEPAGE=https://glm.g-truc.net/
TERMUX_PKG_DESCRIPTION="C++ mathematics library for graphics programming"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="copying.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL="https://github.com/g-truc/glm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6775e47231a446fd086d660ecc18bcd076531cfedd912fbd66e576b118607001
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DGLM_BUILD_TESTS=OFF"
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/doc/glm
	cp -r "$TERMUX_PKG_SRCDIR"/doc "$TERMUX_PREFIX"/share/doc/glm
}
