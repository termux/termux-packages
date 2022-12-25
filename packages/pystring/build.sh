TERMUX_PKG_HOMEPAGE=https://github.com/imageworks/pystring
TERMUX_PKG_DESCRIPTION="C++ functions matching the interface and behavior of python string methods with std::string"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.4
TERMUX_PKG_SRCURL=https://github.com/imageworks/pystring/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=49da0fe2a049340d3c45cce530df63a2278af936003642330287b68cefd788fb
TERMUX_PKG_DEPENDS="libc++"

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/include/pystring \
		$TERMUX_PKG_SRCDIR/pystring.h
}
