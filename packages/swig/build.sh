TERMUX_PKG_HOMEPAGE=https://swig.org
TERMUX_PKG_DESCRIPTION="Generate scripting interfaces to C/C++ code"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE-GPL, LICENSE-UNIVERSITIES, COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.0"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/swig/swig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f7203ef796f61af986c70c05816236cbd0d31b7aa9631e5ab53020ab7804aa9e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, pcre2, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
