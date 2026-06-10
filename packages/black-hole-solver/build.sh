TERMUX_PKG_HOMEPAGE="https://fc-solve.shlomifish.org/"
TERMUX_PKG_DESCRIPTION="Black Hole Solver is a solitaire solver for 'Golf', 'Black Hole' and 'All in a Row'."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="1.14.0"
TERMUX_PKG_SRCURL="https://fc-solve.shlomifish.org/downloads/fc-solve/black-hole-solver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5c47bd093dbb160f4b090fd670ab7c12b4371d39b17b3bbd8c6c4a12975557c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=false
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi
	# Need Perl module Path::Tiny
	termux_download_ubuntu_packages libpath-tiny-perl
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local upkg="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr"
		export PERL5LIB="$upkg/share/perl5"
	fi
}
