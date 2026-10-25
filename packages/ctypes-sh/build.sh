TERMUX_PKG_HOMEPAGE=https://github.com/taviso/ctypes.sh
TERMUX_PKG_DESCRIPTION="A foreign function interface for bash"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=https://github.com/taviso/ctypes.sh/releases/download/v${TERMUX_PKG_VERSION}/ctypes-sh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ab032a845d8e579e39159f9bb8e68214892b2d927e6c70834230c88145892165
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, libelf, libdw, libffi, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vif
}
