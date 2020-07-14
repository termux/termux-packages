TERMUX_PKG_HOMEPAGE=https://github.com/Z3Prover/z3
TERMUX_PKG_DESCRIPTION="Z3 is a theorem prover from Microsoft Research."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=4.8.8
TERMUX_PKG_SRCURL=https://github.com/Z3Prover/z3/archive/z3-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6962facdcdea287c5eeb1583debe33ee23043144d0e5308344e6a8ee4503bcff
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	chmod +x scripts/mk_make.py
	sed '1 s/^.#*$/\#\!\/usr\/bin\/env\ python3/g' -i scripts/mk_make.py
	CXX="$CXX" CC="$CC" scripts/mk_make.py --prefix=$TERMUX_PREFIX --build=$TERMUX_PKG_BUILDDIR
	sed 's/..\/..\/..\/..\/..\///g' -i Makefile
	sed 's/\-lpthread//g' -i config.mk
}
