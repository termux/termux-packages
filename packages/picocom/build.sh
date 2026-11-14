TERMUX_PKG_HOMEPAGE=https://gitlab.com/wsakernel/picocom
TERMUX_PKG_DESCRIPTION="A minimal dumb-terminal emulation program"
# "BSD 2-Clause" applies to bundled Linenoise library
TERMUX_PKG_LICENSE="GPL-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, linenoise-1.0/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2024.07
TERMUX_PKG_SRCURL="https://gitlab.com/wsakernel/picocom/-/archive/${TERMUX_PKG_VERSION//./-}/picocom-${TERMUX_PKG_VERSION//./-}.tar.gz"
TERMUX_PKG_SHA256=4379de2ec591a5848123f37ccdbc7fbeee6dd3520ef1ce4119d84202fc268a17
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="all picocom.1"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin pcasc pc{x,y,z}m picocom
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 picocom.1
}
