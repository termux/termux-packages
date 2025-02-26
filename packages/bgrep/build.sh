TERMUX_PKG_HOMEPAGE=https://debugmo.de/2009/04/bgrep-a-binary-grep/
TERMUX_PKG_DESCRIPTION="Binary string grep tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/rsharo/bgrep/archive/bgrep-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba5ddae672e84bf2d8ce91429a4ce8a5e3a154ee7e64d1016420f7dc7481ec0a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_func_strcasecmp_works=yes
"

termux_step_pre_configure() {
	./bootstrap
}
