TERMUX_PKG_HOMEPAGE=https://github.com/pali/udftools
TERMUX_PKG_DESCRIPTION="Linux tools for UDF filesystems and DVD/CD-R(W) drives"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/pali/udftools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=095e1c8b947849f5f8a1cade23dd3375532bda305a184eb022df96e43c4d6f7e
TERMUX_PKG_DEPENDS="readline"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_configure() {
	local f
	for f in "$TERMUX_PKG_SRCDIR"/include/*.h; do
		ln -sf "${f}" ./include/
	done
}
