TERMUX_PKG_HOMEPAGE="https://github.com/Wilfred/difftastic"
TERMUX_PKG_DESCRIPTION="difft: A structural diff that understands syntax"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.61.0"
TERMUX_PKG_SRCURL="https://github.com/Wilfred/difftastic/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8e85001e32f1fe7b2c6d164f3a654cb589c6e48b6350421df27a56919da7a185
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
# needed for MIME database (optional in upstream)
TERMUX_PKG_RECOMMENDS="file"
