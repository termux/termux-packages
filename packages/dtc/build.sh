TERMUX_PKG_HOMEPAGE=https://git.kernel.org/pub/scm/utils/dtc/dtc
TERMUX_PKG_DESCRIPTION="Device Tree Compiler (dtc) toolchain for working with device tree source"
TERMUX_PKG_SHA256=603d6f4f5f34921b368e6febe6690c89022d098edda77187a758b8eeeeff53ea
TERMUX_PKG_VERSION="1.4.7"
TERMUX_PKG_SRCURL=https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="swig, python"
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
