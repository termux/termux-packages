TERMUX_PKG_HOMEPAGE="https://github.com/Wilfred/difftastic"
TERMUX_PKG_DESCRIPTION="difft: A structural diff that understands syntax"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.33.0"
TERMUX_PKG_SRCURL="https://github.com/Wilfred/difftastic/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=80963d407b413044bc8fc9c8969a1c7a9a6901412e494380d0925c3e4cad5388
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
# needed for MIME database (optional in upstream)
TERMUX_PKG_RECOMMENDS="file"
