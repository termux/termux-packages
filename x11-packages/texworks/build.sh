TERMUX_PKG_HOMEPAGE=https://www.tug.org/texworks/
TERMUX_PKG_DESCRIPTION="TeXworks is an environment for authoring TeX (LaTeX, ConTeXt, etc) documents"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.8"
TERMUX_PKG_SRCURL=https://github.com/TeXworks/texworks/archive/refs/tags/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9fa2aa69bb34951d3249ea607ce3689b6fff9e1f31e353bd1a1cfe33dc995837
TERMUX_PKG_DEPENDS="hunspell, libc++, liblua53, poppler-qt, qt5-qtbase, qt5-qtdeclarative, qt5-qtscript, zlib"
TERMUX_PKG_BUILD_DEPENDS="git, qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUA_MATH_LIBRARY=
"
