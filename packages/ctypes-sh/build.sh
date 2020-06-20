TERMUX_PKG_HOMEPAGE=https://github.com/taviso/ctypes.sh
TERMUX_PKG_DESCRIPTION="A foreign function interface for bash"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/taviso/ctypes.sh/releases/download/v${TERMUX_PKG_VERSION}/ctypes-sh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f7c8276b556101c51838296560d152fdcd96b860254a38d216b92986f31f8297
TERMUX_PKG_DEPENDS="bash, libelf, libdw, libffi, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vif
}
