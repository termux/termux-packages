TERMUX_PKG_HOMEPAGE=https://github.com/lxml/lxml
TERMUX_PKG_DESCRIPTION="Python binding for the libxml2 and libxslt libraries"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.2"
TERMUX_PKG_SRCURL="https://github.com/lxml/lxml/archive/refs/tags/lxml-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d20bde22b4e3955f2648910945e78e03ad7cff7c933b877ad2981027b6bd321b
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="'Cython>=3.2.4'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!.)"
