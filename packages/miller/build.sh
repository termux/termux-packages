TERMUX_PKG_HOMEPAGE=https://miller.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.5.0
TERMUX_PKG_SRCURL=git+https://github.com/johnkerl/miller
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	local dir="$GOPATH"/src/github.com/johnkerl/miller
	mkdir -p "$(dirname "${dir}")"
	ln -sfT "$TERMUX_PKG_SRCDIR" "${dir}"
	TERMUX_PKG_BUILDDIR="${dir}"
	cd "${dir}"
}

termux_step_configure() {
	:
}
