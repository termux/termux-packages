TERMUX_PKG_HOMEPAGE=https://www.tug.org/texworks/
TERMUX_PKG_DESCRIPTION="TeXworks is an environment for authoring TeX (LaTeX, ConTeXt, etc) documents"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.10"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/TeXworks/texworks/archive/refs/tags/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bbc29d5aba451355222b29dd02ef318fd7fec55a721a61fc6d9cd933a0abd270
TERMUX_PKG_DEPENDS="hunspell, libc++, lua53, poppler-qt, qt6-qtbase, qt6-qtdeclarative, qt6-qt5compat, qt6-qttools, zlib"
TERMUX_PKG_BUILD_DEPENDS="git, qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUA_MATH_LIBRARY=
-DQT_DEFAULT_MAJOR_VERSION=6
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DCMAKE_CXX_COMPILER_CLANG_SCAN_DEPS=${TERMUX_STANDALONE_TOOLCHAIN}/bin/clang-scan-deps
	"
}
