TERMUX_PKG_HOMEPAGE="https://www.shellcheck.net/"
TERMUX_PKG_DESCRIPTION="Shell script analysis tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/ShellCheck-${TERMUX_PKG_VERSION}/ShellCheck-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4d08db432d75a34486a55f6fff9d3e3340ce56125c7804b7f8fd14421b936d21
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libffi"
TERMUX_PKG_BUILD_DEPENDS="ghc-libs"
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
# arm build fails complaining that it can't find `opt-13`
# symlinking `opt-16` to `opt-13` does not work. Blacklisting it for now.

termux_step_pre_configure() {
	chmod u+x ./striptests
	./striptests
}
