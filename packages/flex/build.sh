TERMUX_PKG_HOMEPAGE=https://github.com/westes/flex
TERMUX_PKG_DESCRIPTION="Fast lexical analyser generator"
TERMUX_PKG_VERSION=2.6.3
TERMUX_PKG_SRCURL=https://github.com/westes/flex/releases/download/v${TERMUX_PKG_VERSION}/flex-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68b2742233e747c462f781462a2a1e299dc6207401dac8f0bbb316f48565c2aa
TERMUX_PKG_DEPENDS="m4"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="ac_cv_path_M4=$TERMUX_PREFIX/bin/m4"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_CONFLICTS="flex-dev"
TERMUX_PKG_REPLACES="flex-dev"

termux_step_pre_configure() {
	mkdir -p $TERMUX_PKG_BUILDDIR/src/
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/stage1flex $TERMUX_PKG_BUILDDIR/src/stage1flex
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/src/stage1flex
}
