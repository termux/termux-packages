TERMUX_PKG_HOMEPAGE=https://glm.g-truc.net/
TERMUX_PKG_DESCRIPTION="C++ mathematics library for graphics software based on the GLSL specifications"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="copying.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/g-truc/glm/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f3174561fd26904b23f0db5e560971cbf9b3cbda0b280f04d5c379d03bf234c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DGLM_BUILD_TESTS=OFF"
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/doc/glm
	cp -r "$TERMUX_PKG_SRCDIR"/doc "$TERMUX_PREFIX"/share/doc/glm
}
