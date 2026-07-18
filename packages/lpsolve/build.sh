TERMUX_PKG_HOMEPAGE=http://lpsolve.sourceforge.net/
TERMUX_PKG_DESCRIPTION="a Mixed Integer Linear Programming (MILP) solver"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.5.2.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/project/lpsolve/lpsolve/${TERMUX_PKG_VERSION}/lp_solve_${TERMUX_PKG_VERSION}_source.tar.gz"
TERMUX_PKG_SHA256=6d4abff5cc6aaa933ae8e6c17a226df0fc0b671c438f69715d41d09fe81f902f
TERMUX_PKG_BUILD_IN_SRC=true

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
