TERMUX_PKG_HOMEPAGE=https://github.com/lxml/lxml
TERMUX_PKG_DESCRIPTION="Python binding for the libxml2 and libxslt libraries"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.3"
TERMUX_PKG_SRCURL="https://github.com/lxml/lxml/archive/refs/tags/lxml-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=33daa1ae6ec2410fb506befe36fd128ea53ade4dde145e1efdeebff69a76c1d5
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="'Cython>=3.2.4'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?!.)"
