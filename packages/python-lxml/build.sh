TERMUX_PKG_HOMEPAGE=https://github.com/lxml/lxml
TERMUX_PKG_DESCRIPTION="Python binding for the libxml2 and libxslt libraries"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxml/lxml/archive/refs/tags/lxml-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=0002d14d042ee6ee145e812cbd0b0e5ddaf5bedadc774187815309fb44f79801
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="'Cython>=3.2.4'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!.)"
