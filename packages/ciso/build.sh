TERMUX_PKG_HOMEPAGE=https://github.com/jamie/ciso
TERMUX_PKG_DESCRIPTION="PSP ISO compression tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jamie/ciso/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77a9bb615ca8918ef81f21328cb4fdc58f4cdd854cb11c16bb50a7d4d1625c09
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 ./"${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}"/bin
}
