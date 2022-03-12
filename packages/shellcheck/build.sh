TERMUX_PKG_HOMEPAGE="https://www.shellcheck.net/"
TERMUX_PKG_DESCRIPTION="Shell script analysis tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/ShellCheck-${TERMUX_PKG_VERSION}/ShellCheck-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="62080e8a59174b12ecd2d753af3e6b9fed977e6f5f7301cde027a54aee555416"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="ghc-libs, haskell-regex-tdfa, haskell-diff, haskell-quickcheck, haskell-aeson"
TERMUX_PKG_IS_HASKELL_LIB=false

termux_step_pre_configure() {
	./striptests
}
