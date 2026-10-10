TERMUX_PKG_HOMEPAGE=https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities
TERMUX_PKG_DESCRIPTION="ELF utils that can check files for security relevant properties"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.11"
TERMUX_PKG_SRCURL="https://github.com/gentoo/pax-utils/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=aa01db76341e64c9c6895d83f6b5f835a3cc9efdf1c21c72b8e45f1b0add32c7
TERMUX_PKG_DEPENDS="libcap, libseccomp, python, python-pip"
TERMUX_PKG_PYTHON_RUNTIME_DEPS="pyelftools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Duse_fuzzing=false
"
