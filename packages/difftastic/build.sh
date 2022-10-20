TERMUX_PKG_HOMEPAGE="https://github.com/Wilfred/difftastic"
TERMUX_PKG_DESCRIPTION="difft: A structural diff that understands syntax"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.37.0"
TERMUX_PKG_SRCURL="https://github.com/Wilfred/difftastic/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=a49a329bcde18574e8152b055d5bbd2a10aa9c8492ca677fbf8963fad3220949
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
# needed for MIME database (optional in upstream)
TERMUX_PKG_RECOMMENDS="file"
