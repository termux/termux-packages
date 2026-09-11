TERMUX_PKG_HOMEPAGE=https://github.com/MRX7014/arfix
TERMUX_PKG_DESCRIPTION="Fix Arabic text rendering (shaping + BiDi) in terminals"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@MRX7014"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://github.com/MRX7014/arfix/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef4cb8d539b6a0097de7cef1f2fbae57f331817008dab511ef42519b659f0e04
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="python, python-pip"

termux_step_make_install() {
	python3 -m pip install --prefix="$TERMUX_PREFIX" --no-deps .
}
