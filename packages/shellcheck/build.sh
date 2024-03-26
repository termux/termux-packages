TERMUX_PKG_HOMEPAGE="https://www.shellcheck.net/"
TERMUX_PKG_DESCRIPTION="Shell script analysis tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/ShellCheck-${TERMUX_PKG_VERSION}/ShellCheck-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=abbee3b729d525a959b06423a71fe3a17ed07b6220bc84394deffe8cd813331c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libffi"
TERMUX_PKG_BUILD_DEPENDS="ghc-libs"

termux_step_pre_configure() {
	./striptests
}
