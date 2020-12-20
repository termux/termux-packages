TERMUX_PKG_HOMEPAGE=https://github.com/taviso/ctypes.sh
TERMUX_PKG_DESCRIPTION="A foreign function interface for bash"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=https://github.com/taviso/ctypes.sh/releases/download/v${TERMUX_PKG_VERSION}/ctypes-sh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8896334f5fa88f656057bff807ec6921c8f76fc6de801d996d2057fcb18b3a68
TERMUX_PKG_DEPENDS="bash, libelf, libdw, libffi, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vif
}
