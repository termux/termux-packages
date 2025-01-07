TERMUX_PKG_HOMEPAGE=https://editorconfig.org/
TERMUX_PKG_DESCRIPTION="EditorConfig core code written in C (for use by plugins supporting EditorConfig parsing)"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.9"
TERMUX_PKG_SRCURL=https://github.com/editorconfig/editorconfig-core-c/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4aaa4e3883332aac7ec19c169dcf128f5f0f963f61d09beb299eb2bce5944e2c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="pcre2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_DOCUMENTATION=OFF
"
