TERMUX_PKG_HOMEPAGE=https://github.com/lp-solve/lp_solve
TERMUX_PKG_DESCRIPTION="a Mixed Integer Linear Programming (MILP) solver"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.5.2.14"
TERMUX_PKG_SRCURL="https://github.com/lp-solve/lp_solve/releases/download/${TERMUX_PKG_VERSION}/lp_solve_${TERMUX_PKG_VERSION}_source.tar.gz"
TERMUX_PKG_SHA256=a4bbdc881128bdbe920a38e134c9add5db47f9aa814a0a018ba940b0f3c278c3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(git ls-remote --tags --refs https://github.com/lp-solve/lp_solve.git | sed -nE 's|.*refs/tags/([0-9]+(\.[0-9]+)+)$|\1|p' | sort -V | tail -n1)"
	[[ -n "$latest_version" ]] || termux_error_exit "failed to find a lpsolve release"
	termux_pkg_upgrade_version "$latest_version"
}

termux_step_configure() {
	:
}

termux_step_make() {
	cd lpsolve55
	sh -x ccc
	rm -f bin/liblpsolve55.a

	cd ../lp_solve
	sh -x ccc
	cd ..
}

termux_step_make_install() {
	install -dm755 "$TERMUX_PREFIX"/{bin,lib,include/lpsolve}
	install -m755 lp_solve/bin/lp_solve "$TERMUX_PREFIX"/bin/
	install -m755 lpsolve55/bin/liblpsolve55.so "$TERMUX_PREFIX"/lib/
	install -m644 lp*.h "$TERMUX_PREFIX"/include/lpsolve/
	install -D -m644 README.txt -t "$TERMUX_PREFIX/share/licenses/$TERMUX_PKG_NAME/"
}
