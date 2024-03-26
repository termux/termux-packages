TERMUX_PKG_HOMEPAGE="https://github.com/mtshiba/pylyzer"
TERMUX_PKG_DESCRIPTION="A fast static code analyzer & language server for Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.49"
TERMUX_PKG_SRCURL="https://github.com/mtshiba/pylyzer/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c07e9adba4a475cfce76fafbf34fdd7153e2ccecdad3bbb01eb99b53d7b66484
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	rm -f pyproject.toml setup.py
}
