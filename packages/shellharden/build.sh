TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_VERSION=4.0
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=91660e4908bd07105f091a62e6f77bc9ed42045096b38abe31503cd2609cb7a0
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	cp target/$CARGO_TARGET_NAME/release/shellharden $TERMUX_PREFIX/bin/shellharden
}
